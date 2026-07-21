//
//  PoemPair.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 04/06/2026.
//

import Foundation

struct PoemPair {
    static func pairIdentifier(_ poem1: Poem, _ poem2: Poem) -> String {
        poem1.uuid.uuidString + poem2.uuid.uuidString
    }
    
    let poem1: Poem
    let poem2: Poem
    let similarity: Double
}

extension PoemPair: Identifiable {
    var id: String {
        Self.pairIdentifier(poem1, poem2)
    }
}

extension PoemPair: Comparable {
    static func < (lhs: PoemPair, rhs: PoemPair) -> Bool {
        lhs.similarity < rhs.similarity
    }
}

extension PoemPair: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
