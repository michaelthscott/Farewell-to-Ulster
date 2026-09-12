//
//  MDAnchor.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 12/09/2026.
//

import Foundation

struct MDAnchor {
    let classValue: String
    let type: MDType
    let number: String
    let content: String
    
    init(classValue: String = "", type: MDType = .none, number: String = "", content: String = "") {
        self.classValue = classValue
        self.type = type
        self.number = number
        self.content = content
    }
    
    private var filename: String {
        guard !number.isEmpty else { return "" }
        return "\(number).html"
    }
    
    var markdown: String {
        var attributes: [String: String] = ["href": "/Farewell-to-Ulster\(type.path)\(filename)"]
        if !classValue.isEmpty { attributes["class"] = classValue }
        return MDElement(name: "a", attributes: attributes, content: content).markdown
    }
}
