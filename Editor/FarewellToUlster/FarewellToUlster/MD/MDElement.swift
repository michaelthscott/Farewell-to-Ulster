//
//  MDElement.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 12/09/2026.
//

import Foundation

struct MDElement {
    let name: String
    let attributes: [String: String]
    let content: String
    let isMultiline: Bool

    init(name: String, attributes: [String : String] = [:], content: String = "", isMultiline: Bool = false) {
        self.name = name
        self.attributes = attributes
        self.content = content
        self.isMultiline = isMultiline
    }
    
    private var joinedAttributes: String {
        guard attributes.count > 0 else { return "" }
        var array: [String] = [""]
        for key in attributes.keys.sorted() {
            guard let value = attributes[key] else { continue }
            array.append("\(key)=\"\(value)\"")
        }
        return array.joined(separator: " ")
    }
    
    private var formattedContent: String {
        guard isMultiline else { return content }
        return "\n" + content + "\n"
    }
    
    var markdown: String {
        "<\(name)\(joinedAttributes)>\(formattedContent)</\(name)>"
    }
}
