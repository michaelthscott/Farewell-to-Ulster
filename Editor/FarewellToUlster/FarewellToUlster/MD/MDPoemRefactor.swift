//
//  MDPoemRefactor.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 11/09/2026.
//

import Foundation

struct MDPoemRefactor {
    let eraPaddedNumber: String
    let number: Int
    let title: String
    let text: String
    
    var paddedNumber: String {
        String(format: "%04d", number)
    }
    
    var path: String {
        "_Poems/\(paddedNumber).md"
    }
    
    var markdownText: String {
        convertToMarkdown(text)
    }
    
    var markdown: String {
        """
---
layout: poem
title: \(title)
---
\(markdownText)
"""
    }
    
    var data: Data {
        Data(markdown.utf8)
    }
}
