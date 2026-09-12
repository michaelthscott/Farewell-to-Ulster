//
//  MDBreadcrumb.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 12/09/2026.
//

import Foundation

struct MDBreadcrumb {
    let eraInfo: MDInfo?

    init(eraInfo: MDInfo? = nil) {
        self.eraInfo = eraInfo
    }
    
    private var root: String {
        MDAnchor(content: "Farewell to Ulster").markdown
    }
    
    private var leaf: String {
        guard let eraInfo else { return MDAnchor().markdown }
        return MDAnchor(type: .era, number: eraInfo.number, content: eraInfo.title).markdown
    }
    
    private var content: String {
        """
\(root) /
\(leaf)
"""
    }
    
    var markdown: String {
        MDElement(name: "nav", attributes: ["class": "breadcrumb"], content: content, isMultiline: true).markdown
    }
}
