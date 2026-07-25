//
//  GitHubTests.swift
//  FarewellToUlsterTests
//
//  Created by Michael Scott on 25/07/2026.
//

import Foundation
import Testing
@testable import FarewellToUlster

struct GitHubTests {

    @Test func testGitHubBatchCommitter() async throws {
        let committer = GitHubBatchCommitter(owner: "michaelthscott", repo: "Farewell-to-Ulster", branch: "main")
        try await committer.commitFiles([
            "_Eras/01.md": "---\ntitle: Before Anything\n---\nThings I heard about or imagined from the earlier world.",
            "_Eras/02.md": "---\ntitle: Longshot\n---\nOur house and garden. A child at home.",
            "_Eras/03.md": "---\ntitle: Inchmarlo Boys\n---\nThe shock of going to school. All those other boys with their different family lives."
        ], message: "Testing batch commit")
    }

}
