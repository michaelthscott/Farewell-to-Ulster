//
//  MDEra.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 11/09/2026.
//

import Foundation

struct MDEra {
    let info: MDInfo
    let text: String
    let poems: [MDPoem]
    
    var path: String {
        "_Eras/\(info.number).md"
    }
    
    var breadcrumb: String {
        MDBreadcrumb().markdown
    }
    
    var heading: String {
        MDHeading(title: info.title).markdown
    }

    var list: String {
        var list: [String] = ["<ul>"]
        for poem in poems {
            list.append("<li>" + MDAnchor(type: .poem, number: poem.info.number, content: poem.info.title).markdown + "</li>")
        }
        list.append("</ul>")
        return list.joined(separator: "\n")
    }
    
    var markdown: String {
        """
---
layout: era
title: \(info.title)
---
\(breadcrumb)

\(heading)

\(text)

\(list)
"""
    }
    
    var data: Data {
        Data(markdown.utf8)
    }
}
