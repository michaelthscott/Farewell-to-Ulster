//
//  GitHubCommitError.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 25/07/2026.
//

import Foundation

enum GitHubCommitError: LocalizedError {
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
