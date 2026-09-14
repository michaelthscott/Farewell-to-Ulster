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
    let previousInfo: MDInfo
    let nextInfo: MDInfo
    let text: String

    var path: String {
        "_Poems/\(info.number).md"
    }
    
    var breadcrumb: String {
        MDBreadcrumb(info: eraInfo).markdown
    }
    
    var heading: String {
        MDHeading(title: info.title).markdown
    }
    
    var previousNext: String {
        html("nav", ["class": "prev-next"]) {
            if previousInfo.type == .poem {
                html("a", ["class": "prev", "href": "\(previousInfo.type.path)\(previousInfo.number).html"], inline: true) {
                    "← \(previousInfo.title)"
                }
            } else {
                html("span", inline: true) {}
            }
            
            if nextInfo.type == .poem {
                html("a", ["class": "next", "href": "\(nextInfo.type.path)\(nextInfo.number).html"], inline: true) {
                    "\(nextInfo.title) →"
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
