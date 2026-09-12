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
        let h1 = MDElement(name: "h1", attributes: ["class": "post-title"], content: title).markdown
        return MDElement(name: "header", attributes: ["class": "post-header"], content: h1, isMultiline: true).markdown
    }
}
