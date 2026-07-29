//
//  GitHubBatchCommitter.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 25/07/2026.
//

import Foundation

struct GitHubBatchCommitter {
    let owner: String
    let repo: String
    let branch: String

    private var baseURL: String { "https://api.github.com/repos/\(owner)/\(repo)" }

    private func request(_ path: String, method: String = "GET", body: Data? = nil) throws -> URLRequest {
        guard let token = try iCloudKeychain.load() else {
            throw GitHubCommitError.noToken
        }
        
        var req = URLRequest(url: URL(string: "\(baseURL)\(path)")!)
        req.httpMethod = method
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        req.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        if let body { req.httpBody = body }
        return req
    }

    func commitFiles(_ files: [String: String], message: String) async throws {
        let (refData, _) = try await URLSession.shared.data(for: try request("/git/ref/heads/\(branch)"))
        let ref = try JSONDecoder().decode(RefResponse.self, from: refData)
        let latestCommitSHA = ref.object.sha

        let (commitData, _) = try await URLSession.shared.data(for: try request("/git/commits/\(latestCommitSHA)"))
        let commit = try JSONDecoder().decode(CommitResponse.self, from: commitData)
        let baseTreeSHA = commit.tree.sha

        var treeEntries: [TreeEntry] = []
        for (path, content) in files {
            let blobBody = try JSONEncoder().encode(BlobRequest(content: content, encoding: "utf-8"))
            let (blobData, _) = try await URLSession.shared.data(for: try request("/git/blobs", method: "POST", body: blobBody))
            let blob = try JSONDecoder().decode(BlobResponse.self, from: blobData)
            treeEntries.append(TreeEntry(path: path, mode: "100644", type: "blob", sha: blob.sha))
        }

        let treeBody = try JSONEncoder().encode(NewTreeRequest(base_tree: baseTreeSHA, tree: treeEntries))
        let (treeData, _) = try await URLSession.shared.data(for: try request("/git/trees", method: "POST", body: treeBody))
        let newTree = try JSONDecoder().decode(TreeResponse.self, from: treeData)

        let newCommitBody = try JSONEncoder().encode(NewCommitRequest(message: message, tree: newTree.sha, parents: [latestCommitSHA]))
        let (newCommitData, _) = try await URLSession.shared.data(for: try request("/git/commits", method: "POST", body: newCommitBody))
        let newCommit = try JSONDecoder().decode(CommitResponse.self, from: newCommitData)

        let updateRefBody = try JSONEncoder().encode(UpdateRefRequest(sha: newCommit.sha, force: false))
        let (_, updateResp) = try await URLSession.shared.data(for: try request("/git/refs/heads/\(branch)", method: "PATCH", body: updateRefBody))
        guard let http = updateResp as? HTTPURLResponse, http.statusCode == 200 else {
            throw NSError(domain: "GitHubCommit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to update ref"])
        }
    }
}

// MARK: - Codable models
struct RefResponse: Codable { let object: RefObject }
struct RefObject: Codable { let sha: String }
struct CommitResponse: Codable { let sha: String; let tree: TreeRef }
struct TreeRef: Codable { let sha: String }
struct BlobRequest: Codable { let content: String; let encoding: String }
struct BlobResponse: Codable { let sha: String }
struct TreeResponse: Codable { let sha: String }
struct TreeEntry: Codable { let path: String; let mode: String; let type: String; let sha: String }
struct NewTreeRequest: Codable { let base_tree: String; let tree: [TreeEntry] }
struct NewCommitRequest: Codable { let message: String; let tree: String; let parents: [String] }
struct UpdateRefRequest: Codable { let sha: String; let force: Bool }
