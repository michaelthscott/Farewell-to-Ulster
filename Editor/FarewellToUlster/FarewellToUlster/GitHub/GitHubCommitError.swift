//
//  GitHubCommitError.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 25/07/2026.
//

import Foundation

enum GitHubCommitError: LocalizedError {
    case noToken
    case unauthorized
    case requestFailed(Int, String)

    var errorDescription: String? {
        switch self {
        case .noToken:
            return "No GitHub token found in Keychain. Save one first."
        case .unauthorized:
            return "GitHub rejected the token. It may have expired."
        case .requestFailed(let code, let message):
            return "GitHub API error \(code): \(message)"
        }
    }

    /// True when the fix is for the user to enter a new token.
    var needsToken: Bool {
        switch self {
        case .noToken, .unauthorized:
            return true
        case .requestFailed:
            return false
        }
    }
}
