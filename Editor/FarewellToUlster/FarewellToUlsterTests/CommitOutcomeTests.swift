//
//  CommitOutcomeTests.swift
//  FarewellToUlsterTests
//
//  Created by Michael Scott on 20/09/2026.
//

import Foundation
import Testing
@testable import FarewellToUlster

struct CommitOutcomeTests {

    /// An error from outside the GitHub layer, e.g. URLSession or a decoder.
    private struct UnrelatedError: Error {}

    @Test func testNothingAttempted() async throws {
        let outcome = CommitOutcome()
        #expect(outcome.title == "Update complete")
        #expect(outcome.message == "Everything was already up to date.")
        #expect(outcome.needsToken == false)
    }

    @Test func testEverythingAlreadyUpToDate() async throws {
        var outcome = CommitOutcome()
        outcome.record(target: "JSON file", commitSHA: nil)
        outcome.record(target: "Longshot", commitSHA: nil)
        #expect(outcome.committed.isEmpty)
        #expect(outcome.unchanged.count == 2)
        #expect(outcome.message == "Everything was already up to date.")
    }

    /// The eras that changed are named, so the summary confirms what actually went up.
    @Test func testCommittedTargetsAreNamed() async throws {
        var outcome = CommitOutcome()
        outcome.record(target: "JSON file", commitSHA: "abc123")
        outcome.record(target: "Before Anything", commitSHA: "def456")
        outcome.record(target: "Longshot", commitSHA: nil)
        #expect(outcome.title == "Update complete")
        #expect(outcome.message == "Committed 2: JSON file, Before Anything. 1 already up to date.")
    }

    @Test func testUnchangedIsOmittedWhenEverythingCommitted() async throws {
        var outcome = CommitOutcome()
        outcome.record(target: "Longshot", commitSHA: "abc123")
        #expect(outcome.message == "Committed 1: Longshot.")
    }

    @Test func testFailureIsNamedInTheMessage() async throws {
        var outcome = CommitOutcome()
        outcome.record(target: "JSON file", commitSHA: "abc123")
        outcome.record(target: "Longshot", error: GitHubCommitError.requestFailed(404, "Not Found"))
        #expect(outcome.title == "Commit failed")
        #expect(outcome.message == """
            Committed 1: JSON file. 1 failed.

            Longshot: GitHub API error 404: Not Found
            """)
    }

    @Test func testEveryFailureIsListed() async throws {
        var outcome = CommitOutcome()
        outcome.record(target: "Before Anything", error: GitHubCommitError.requestFailed(409, "Conflict"))
        outcome.record(target: "Longshot", error: GitHubCommitError.requestFailed(404, "Not Found"))
        #expect(outcome.message == """
            2 failed.

            Before Anything: GitHub API error 409: Conflict

            Longshot: GitHub API error 404: Not Found
            """)
    }

    @Test func testBuildFailureBeforeAnyRequest() async throws {
        var outcome = CommitOutcome()
        outcome.record(target: "JSON file", message: "Could not encode the JSON file.")
        #expect(outcome.title == "Commit failed")
        #expect(outcome.needsToken == false)
        #expect(outcome.message == """
            1 failed.

            JSON file: Could not encode the JSON file.
            """)
    }

    @Test func testTokenErrorsAskForANewToken() async throws {
        var missing = CommitOutcome()
        missing.record(target: "JSON file", error: GitHubCommitError.noToken)
        #expect(missing.needsToken)

        var expired = CommitOutcome()
        expired.record(target: "JSON file", error: GitHubCommitError.unauthorized)
        #expect(expired.needsToken)
    }

    @Test func testOtherErrorsDoNotAskForANewToken() async throws {
        var outcome = CommitOutcome()
        outcome.record(target: "JSON file", error: GitHubCommitError.requestFailed(403, "API rate limit exceeded"))
        outcome.record(target: "Longshot", error: UnrelatedError())
        #expect(outcome.needsToken == false)
    }

    /// One token failure among several is still enough to offer the token sheet.
    @Test func testTokenErrorAmongOthers() async throws {
        var outcome = CommitOutcome()
        outcome.record(target: "Before Anything", error: GitHubCommitError.requestFailed(500, "Server Error"))
        outcome.record(target: "Longshot", error: GitHubCommitError.unauthorized)
        #expect(outcome.needsToken)
    }
}
