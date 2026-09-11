//
//  MDUtilities.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 11/09/2026.
//

import Foundation

func convertToMarkdown(_ text: String) -> String {
    let paragraphs = text
        .components(separatedBy: "\n\n")
        .map { paragraph -> String in
            let lines = paragraph
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: "\n")

            // Add a hard-break marker to every line except the last
            return lines.enumerated().map { index, line in
                index < lines.count - 1 ? line + "\\" : line
            }.joined(separator: "\n")
        }
        .filter { !$0.isEmpty }

    return paragraphs.joined(separator: "\n\n")
}
