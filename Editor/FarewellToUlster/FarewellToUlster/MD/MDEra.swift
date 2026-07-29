//
//  MDEra.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 28/07/2026.
//

import Foundation

struct MDEra {
    let number: Int
    let title: String
    let text: String
    
    var paddedNumber: String {
        String(format: "%02d", number)
    }
    
    var path: String {
        "_Eras/\(paddedNumber).md"
    }
    
    var markdown: String {
        """
---
layout: era
title: \(title)
collection: Era\(paddedNumber)
---
\(text)
"""
    }
    
    var data: Data {
        Data(markdown.utf8)
    }
}
