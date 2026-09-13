//
//  MDHeading.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 12/09/2026.
//

import Foundation

struct MDHeading {
    let title: String
    
    var markdown: String {
        html("header", ["class": "post-header"]) {
            html("h1", ["class": "post-title"], inline: true) { title }
        }
    }
}
