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
        html("nav", ["class": "prev-next"]) {
            if let previousNumber, let previousTitle {
                html("a", ["class": "prev", "href": "/Farewell-to-Ulster/Poems/\(previousNumber).html"], inline: true) {
                    "← \(previousTitle)"
                }
            } else {
                html("span", inline: true) {}
            }
            
            if let nextNumber, let nextTitle {
                html("a", ["class": "next", "href": "/Farewell-to-Ulster/Poems/\(nextNumber).html"], inline: true) {
                    "\(nextTitle) →"
                }
            } else {
                html("span", inline: true) {}
            }
        }
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
