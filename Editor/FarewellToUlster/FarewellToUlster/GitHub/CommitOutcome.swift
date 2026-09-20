//
//  CommitOutcome.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 20/09/2026.
//

import Foundation

/// A single commit that failed, named so the user can tell which one.
struct CommitFailure: Identifiable {
    let id = UUID()
    let target: String
    let message: String
    let needsToken: Bool

    init(target: String, error: any Error) {
        self.target = target
        self.message = error.localizedDescription
        self.needsToken = (error as? GitHubCommitError)?.needsToken ?? false
    }

    init(target: String, message: String) {
        self.target = target
        self.message = message
        self.needsToken = false
    }
}

/// The result of an update, which spans one commit for the JSON file plus one per era.
struct CommitOutcome {
    private(set) var committed: [String] = []
    private(set) var unchanged: [String] = []
    private(set) var failures: [CommitFailure] = []

    /// True when at least one failure is fixed by entering a new token.
    var needsToken: Bool { failures.contains(where: \.needsToken) }

    var title: String { failures.isEmpty ? "Update complete" : "Commit failed" }

    var message: String {
        var lines = [summary]
        lines.append(contentsOf: failures.map { "\($0.target): \($0.message)" })
        return lines.joined(separator: "\n\n")
    }

    private var summary: String {
        if committed.isEmpty && failures.isEmpty {
            return "Everything was already up to date."
        }
        var parts: [String] = []
        if !committed.isEmpty {
            parts.append("Committed \(committed.count): \(committed.joined(separator: ", "))")
        }
        if !unchanged.isEmpty {
            parts.append("\(unchanged.count) already up to date")
        }
        if !failures.isEmpty {
            parts.append("\(failures.count) failed")
        }
        return parts.joined(separator: ". ") + "."
    }

    /// `batchCommit` returns nil when the content already matched the remote.
    mutating func record(target: String, commitSHA: String?) {
        if commitSHA == nil {
            unchanged.append(target)
        } else {
            committed.append(target)
        }
    }

    mutating func record(target: String, error: any Error) {
        failures.append(CommitFailure(target: target, error: error))
    }

    mutating func record(target: String, message: String) {
        failures.append(CommitFailure(target: target, message: message))
    }
}
