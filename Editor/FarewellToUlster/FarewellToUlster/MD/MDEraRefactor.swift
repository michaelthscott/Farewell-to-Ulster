//
//  MDEraRefactor.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 11/09/2026.
//

import Foundation

struct MDEraRefactor {
    let number: String
    let title: String
    let text: String
    let poems: [MDPoemRefactor]
    
    var paddedNumber: String {
        number
    }
    
    var path: String {
        "_ErasRefactor/\(paddedNumber).md"
    }
    
    var list: String {
        var list: [String] = ["<ul>"]
        for poem in poems {
            list.append("<li><a href=\"\(poem.url)\">\(poem.title)</a></li>")
        }
        list.append("</ul>")
        return list.joined(separator: "\n")
    }
    
    var markdown: String {
        """
---
layout: era-refactor
title: \(title)
---
\(text)

\(list)

"""
    }
    
    var data: Data {
        Data(markdown.utf8)
    }
}
