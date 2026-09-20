//
//  GitHubTests.swift
//  FarewellToUlsterTests
//
//  Created by Michael Scott on 25/07/2026.
//

import Foundation
import Testing
@testable import FarewellToUlster

// TODO: Create some test files so that these tests can be independent of the main content.

struct GitHubTests {

    @Test func testErrorDescriptions() async throws {
        #expect(GitHubCommitError.noToken.errorDescription == "No GitHub token found in Keychain. Save one first.")
        #expect(GitHubCommitError.unauthorized.errorDescription == "GitHub rejected the token. It may have expired.")
        #expect(GitHubCommitError.requestFailed(404, "Not Found").errorDescription == "GitHub API error 404: Not Found")
    }

    @Test func testNeedsToken() async throws {
        #expect(GitHubCommitError.noToken.needsToken)
        #expect(GitHubCommitError.unauthorized.needsToken)
        // 403 covers rate limiting and scope as well as credentials, so it is not a token prompt.
        #expect(GitHubCommitError.requestFailed(403, "API rate limit exceeded").needsToken == false)
    }

//    @Test func testGitHubClient() async throws {
//        let client = GitHubClient(owner: "michaelthscott", repo: "Farewell-to-Ulster", branch: "main")
//        let files = [LocalFile(path: "_Eras/01.md", content: Data("---\ntitle: Before Anything\n---\nThings I heard about or imagined from the earlier world.".utf8)),
//                     LocalFile(path: "_Eras/02.md", content: Data("---\ntitle: Longshot\n---\nOur house in a big garden. A child at home.".utf8))]
//        let sha = try await client.batchCommit(files: files, message: "GitHubClient test")
//        print("sha = \(String(describing: sha))")
//    }
}
