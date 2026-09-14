//
//  Neighbours.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 14/09/2026.
//

import Foundation

enum CursorType {
    case first
    case last
    case only
    case middle
}

struct Cursor {
    let previous: Poem?
    let current: Poem
    let next: Poem?
    
    var previousInfo: MDInfo {
        guard let previous else {
            return .none
        }
        return .poem(title: previous.title, number: previous.fileOrder)
    }
    
    var currentInfo: MDInfo {
        .poem(title: current.title, number: current.fileOrder)
    }
    
    var currentText: String {
        current.text
    }
    
    var nextInfo: MDInfo {
        guard let next else {
            return .none
        }
        return .poem(title: next.title, number: next.fileOrder)
    }
}

struct Neighbours: @MainActor RandomAccessCollection {
    let poems: [Poem]

    var startIndex: Int { poems.startIndex }
    var endIndex: Int { poems.endIndex }

    subscript(position: Int) -> Cursor {
        let previous = position > startIndex ? poems[position - 1] : nil
        let current = poems[position]
        let next = position < index(before: endIndex) ? poems[position + 1] : nil
        return Cursor(previous: previous, current: current, next: next)
    }

    func index(after i: Int) -> Int { i + 1 }
    func index(before i: Int) -> Int { i - 1 }
}

extension Array where Element: Poem {
    var neighbours: Neighbours {
        Neighbours(poems: self)
    }
}
