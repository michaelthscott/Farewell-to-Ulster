//
//  GitHubCommitter.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 22/07/2026.
//

import Foundation

enum GitHubCommitterError: LocalizedError {
    case noToken
    case requestFailed(Int, String)

    var errorDescription: String? {
        switch self {
        case .noToken:
            return "No GitHub token found in Keychain. Save one first."
        case .requestFailed(let code, let body):
            return "GitHub API error \(code): \(body)"
        }
    }
}

struct GitHubCommitter {
    let owner: String
    let repo: String
    
    private func authorizedRequest(url: URL, method: String) throws -> URLRequest {
        guard let token = try GitHubKeychain.load() else {
            throw GitHubCommitterError.noToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        return request
    }
    
    func commitFile(path: String, content: String, message: String, branch: String = "main") async throws {
        let url = URL(string: "https://api.github.com/repos/\(owner)/\(repo)/contents/\(path)")!
        
        // Check if file exists, to get sha for update
        var sha: String? = nil
        let getRequest = try authorizedRequest(url: url, method: "GET")
        if let (data, response) = try? await URLSession.shared.data(for: getRequest),
           let http = response as? HTTPURLResponse, http.statusCode == 200,
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            sha = json["sha"] as? String
        }
        
        var request = try authorizedRequest(url: url, method: "PUT")
        
        let base64Content = Data(content.utf8).base64EncodedString()
        var body: [String: Any] = [
            "message": message,
            "content": base64Content,
            "branch": branch
        ]
        if let sha { body["sha"] = sha }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        guard (200...299).contains(statusCode) else {
            let errorBody = String(data: data, encoding: .utf8) ?? "unknown"
            throw GitHubCommitterError.requestFailed(statusCode, errorBody)
        }
    }
}
