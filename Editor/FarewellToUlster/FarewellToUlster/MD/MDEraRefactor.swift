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
    
    var paddedNumber: String {
        number
    }
    
    var path: String {
        "_ErasRefactor/\(paddedNumber).md"
    }
    
    var markdown: String {
        """
---
layout: era
title: \(title)
---
\(text)
"""
    }
    
    var data: Data {
        Data(markdown.utf8)
    }
}
