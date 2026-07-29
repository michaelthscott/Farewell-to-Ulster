//
//  MDPoem.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 28/07/2026.
//

import Foundation

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

struct MDPoem {
    let eraPaddedNumber: String
    let number: Int
    let title: String
    let text: String
    
    var paddedNumber: String {
        String(format: "%03d", number)
    }
    
    var path: String {
        "_Era\(eraPaddedNumber)/\(paddedNumber).md"
    }
    
    var markdownText: String {
        convertToMarkdown(text)
    }
    
    var markdown: String {
        """
---
layout: poem
title: \(title)
series: Era\(eraPaddedNumber)
---
\(markdownText)
"""
    }
    
    var data: Data {
        Data(markdown.utf8)
    }
}
