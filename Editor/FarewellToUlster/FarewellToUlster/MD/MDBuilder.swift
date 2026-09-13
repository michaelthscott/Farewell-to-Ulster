//
//  MDBuilder.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/09/2026.
//

import Foundation

@resultBuilder
struct MDBuilder {
    static func buildBlock(_ components: String...) -> String {
        components.joined(separator: "\n")
    }
    static func buildExpression(_ expression: String) -> String {
        expression
    }
    static func buildOptional(_ component: String?) -> String {
        component ?? ""
    }
    static func buildEither(first: String) -> String { first }
    static func buildEither(second: String) -> String { second }
    static func buildArray(_ components: [String]) -> String {
        components.joined(separator: "\n")
    }
}

func html(
    _ tag: String,
    _ attrs: [String: String] = [:],
    inline: Bool = false,
    @MDBuilder content: () -> String
) -> String {
    let attrString = attrs.keys.sorted().map { " \($0)=\"\(attrs[$0]!)\"" }.joined()
    let body = content()
    return inline
        ? "<\(tag)\(attrString)>\(body)</\(tag)>"
        : "<\(tag)\(attrString)>\n\(body)\n</\(tag)>"
}
