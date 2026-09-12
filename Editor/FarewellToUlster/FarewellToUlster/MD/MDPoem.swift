//
//  MDPoem.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 11/09/2026.
//

import Foundation

struct MDPoem {
    let eraInfo: MDInfo
    let info: MDInfo
    let text: String
    let previousNumber: String?
    let previousTitle: String?
    let nextNumber: String?
    let nextTitle: String?

    var path: String {
        "_Poems/\(info.number).md"
    }
    
    var breadcrumb: String {
        MDBreadcrumb(eraInfo: eraInfo).markdown
    }
    
    var heading: String {
        MDHeading(title: info.title).markdown
    }
    
    var previousNext: String {
        MDElement(name: "nav", attributes: ["class": "prev-next"], content: """
\(previousLink)
\(nextLink)
""", isMultiline: true).markdown
    }
    
    var previousLink: String {
        guard let previousNumber, let previousTitle else {
            return MDElement(name: "span").markdown
        }
        return MDAnchor(classValue: "prev", type: .poem, number: previousNumber, content: "← \(previousTitle)").markdown
    }
    
    var nextLink: String {
        guard let nextNumber, let nextTitle else {
            return MDElement(name: "span").markdown
        }
        return MDAnchor(classValue: "next", type: .poem, number: nextNumber, content: "\(nextTitle) →").markdown
    }
    
    var markdownText: String {
        convertToMarkdown(text)
    }
    
    var markdown: String {
        """
---
layout: poem
title: \(info.title)
---
\(breadcrumb)

\(heading)

\(markdownText)

\(previousNext)
"""
    }
    
    var data: Data {
        Data(markdown.utf8)
    }
}
