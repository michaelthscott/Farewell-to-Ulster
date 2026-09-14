//
//  MDBreadcrumb.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 12/09/2026.
//

import Foundation

struct MDBreadcrumb {
    let info: MDInfo

    var markdown: String {
        html("nav", ["class": "breadcrumb"]) {
            html("a", ["href": "/Farewell-to-Ulster/"], inline: true) { "Farewell to Ulster" } + " /"
            if info.type == .era {
                a(info: info)
            } else {
                a(info: .none)
            }
        }
    }
}
