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
    
    var markdown: String {
        html("nav", ["class": "breadcrumb"]) {
            html("a", ["href": "/Farewell-to-Ulster/"], inline: true) { "Farewell to Ulster" } + " /"
            if let eraInfo {
                html("a", ["href": "/Farewell-to-Ulster/Eras/\(eraInfo.number).html"], inline: true) { eraInfo.title }
            } else {
                html("a", ["href": ""], inline: true) { }
            }
        }
    }
}
