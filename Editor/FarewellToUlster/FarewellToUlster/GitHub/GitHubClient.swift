//
//  GitHubClient.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 27/07/2026.
//

import Foundation
import CryptoKit

struct LocalFile {
    let path: String
    let content: Data
}

struct GitHubClient {
    /// Computes the SHA-1 a `git` blob .
    static func gitBlobSHA1(for data: Data) -> String {
        let header = "blob \(data.count)\0"
        var toHash = Data(header.utf8)
        toHash.append(data)
        let digest = Insecure.SHA1.hash(data: toHash)
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    let owner: String
    let repo: String
    let branch: String

    private var baseURL: URL { URL(string: "https://api.github.com/repos/\(owner)/\(repo)")! }

    /// Commits only the files whose content differs from what's currently on GitHub.
    /// Returns the new commit SHA, or nil if nothing had changed.
    @discardableResult
    func batchCommit(files: [LocalFile], message: String) async throws -> String? {
        let (commitSHA, treeSHA, remoteBlobs) = try await currentTree()

        var changedEntries: [GitHubClient.NewTreeEntry] = []
        for file in files {
            let localSHA = Self.gitBlobSHA1(for: file.content)
            if remoteBlobs[file.path] == localSHA {
                continue
            }
            let blobSHA = try await createBlob(content: file.content)
            changedEntries.append(.init(path: file.path, sha: blobSHA))
        }

        guard !changedEntries.isEmpty else { return nil }

        let newTreeSHA = try await createTree(baseTreeSHA: treeSHA, entries: changedEntries)
        let newCommitSHA = try await createCommit(message: message, treeSHA: newTreeSHA, parentSHA: commitSHA)
        try await updateRef(to: newCommitSHA)
        return newCommitSHA
    }

    private func url(for path: String) -> URL {
        let parts = path.split(separator: "?", maxSplits: 1)
        let pathOnly = String(parts[0])
        var components = URLComponents(
            url: baseURL.appendingPathComponent(pathOnly),
            resolvingAgainstBaseURL: false
        )!
        if parts.count > 1 {
            components.percentEncodedQuery = String(parts[1])
        }
        return components.url!
    }

    private func request(_ path: String, method: String = "GET", body: (any Encodable)? = nil) async throws -> Data {
        guard let token = try iCloudKeychain.load() else {
            throw GitHubCommitError.noToken
        }
        var req = URLRequest(url: url(for: path))
        req.httpMethod = method
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        if let body {
            req.httpBody = try JSONEncoder().encode(body)
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let (data, response) = try await URLSession.shared.data(for: req)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw NSError(domain: "GitHub", code: (response as? HTTPURLResponse)?.statusCode ?? -1,
                           userInfo: [NSLocalizedDescriptionKey: body])
        }
        return data
    }

    struct TreeEntry: Decodable {
        let path: String
        let sha: String
        let type: String
    }
    struct TreeResponse: Decodable {
        let sha: String
        let tree: [TreeEntry]
    }

    /// Fetches the full recursive tree for the branch's current commit,
    /// returning the head commit SHA, the tree SHA, and a path -> blobSHA map.
    func currentTree() async throws -> (commitSHA: String, treeSHA: String, blobsByPath: [String: String]) {
        struct RefResponse: Decodable { struct Obj: Decodable { let sha: String }; let object: Obj }
        let refData = try await request("git/refs/heads/\(branch)")
        let commitSHA = try JSONDecoder().decode(RefResponse.self, from: refData).object.sha

        struct CommitResponse: Decodable { struct Tree: Decodable { let sha: String }; let tree: Tree }
        let commitData = try await request("git/commits/\(commitSHA)")
        let treeSHA = try JSONDecoder().decode(CommitResponse.self, from: commitData).tree.sha

        let treeData = try await request("git/trees/\(treeSHA)?recursive=1")
        let tree = try JSONDecoder().decode(TreeResponse.self, from: treeData)
        let blobsByPath = Dictionary(uniqueKeysWithValues: tree.tree
            .filter { $0.type == "blob" }
            .map { ($0.path, $0.sha) })

        return (commitSHA, treeSHA, blobsByPath)
    }

    struct BlobResponse: Decodable { let sha: String }

    func createBlob(content: Data) async throws -> String {
        struct BlobRequest: Encodable { let content: String; let encoding = "base64" }
        let body = BlobRequest(content: content.base64EncodedString())
        let data = try await request("git/blobs", method: "POST", body: body)
        return try JSONDecoder().decode(BlobResponse.self, from: data).sha
    }

    struct NewTreeEntry: Encodable {
        let path: String
        let mode = "100644"
        let type = "blob"
        let sha: String
    }

    func createTree(baseTreeSHA: String, entries: [NewTreeEntry]) async throws -> String {
        struct TreeRequest: Encodable { let base_tree: String; let tree: [NewTreeEntry] }
        let body = TreeRequest(base_tree: baseTreeSHA, tree: entries)
        let data = try await request("git/trees", method: "POST", body: body)
        return try JSONDecoder().decode(BlobResponse.self, from: data).sha // same shape: { sha }
    }

    func createCommit(message: String, treeSHA: String, parentSHA: String) async throws -> String {
        struct CommitRequest: Encodable { let message: String; let tree: String; let parents: [String] }
        let body = CommitRequest(message: message, tree: treeSHA, parents: [parentSHA])
        let data = try await request("git/commits", method: "POST", body: body)
        return try JSONDecoder().decode(BlobResponse.self, from: data).sha
    }

    func updateRef(to commitSHA: String) async throws {
        struct RefUpdate: Encodable { let sha: String; let force = false }
        _ = try await request("git/refs/heads/\(branch)", method: "PATCH", body: RefUpdate(sha: commitSHA))
    }
}

