//
//  MDPoemRefactor.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 11/09/2026.
//

import Foundation

struct MDPoemRefactor {
    let eraPaddedNumber: String
    let eraTitle: String
    let number: String
    let title: String
    let text: String
    let previousNumber: String?
    let previousTitle: String?
    let nextNumber: String?
    let nextTitle: String?

    var paddedNumber: String {
        number
    }
    
    var path: String {
        "_Poems/\(paddedNumber).md"
    }
    
    var url: String {
        "/Farewell-to-Ulster/Poems/\(paddedNumber).html"
    }
    
    var breadcrumb: String {
        """
      <nav class="breadcrumb">
        <a href="/Farewell-to-Ulster/">Farewell to Ulster</a> /
        <a href="/Farewell-to-Ulster/\(eraPaddedNumber).html">\(eraTitle)</a>
      </nav>
"""
    }
    
    var previousNext: String {
        """
<nav class="prev-next">
    \(previousLink)
    \(nextLink)
</nav>
"""
    }
    var previousLink: String {
        guard let previousNumber, let previousTitle else {
            return "<span></span>"
        }
        return "<a class=\"prev\" href=\"/Farewell-to-Ulster/Poems/\(previousNumber).html\">← \(previousTitle)</a>"
    }
    
    var nextLink: String {
        guard let nextNumber, let nextTitle else {
            return "<span></span>"
        }
        return "<a class=\"prev\" href=\"/Farewell-to-Ulster/Poems/\(nextNumber).html\">\(nextTitle) →</a>"
    }
    
    var markdownText: String {
        convertToMarkdown(text)
    }
    
    var markdown: String {
        """
---
layout: poem-refactor
title: \(title)
---
\(breadcrumb)
\(markdownText)
\(previousNext)
"""
    }
    
    var data: Data {
        Data(markdown.utf8)
    }
}
