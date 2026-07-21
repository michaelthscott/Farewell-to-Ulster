//
//  Poem.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation
import SwiftData

/// A poem is a text associated with an era, and number of events and or subjects.
@Model
nonisolated final class Poem: Titled, FileOrdered, SortOrderable {
    var fileOrder: String
    var uuid: UUID
    var title: String
    var text: String
    var scratchpad: String = ""
    var status: PoemStatus?
    var category: PoemCategory?
    @Relationship(inverse: \Era.poems) var era: Era?
    @Relationship(inverse: \Event.poems) var events: [Event]?
    @Relationship(inverse: \Subject.poems) var subjects: [Subject]?
    
    init(fileOrder: String = "0000", uuid: UUID = UUID(), title: String = "Untitled", text: String = "") {
        self.fileOrder = fileOrder
        self.uuid = uuid
        self.title = title
        self.text = text
    }
    
    var isCategorised: Bool {
        category != nil
    }
    
    var titleIsFirstLine: Bool {
        guard let firstLine = text.split(separator: "\n").first else {
            return false
        }
        return title.lowercased() == firstLine.lowercased()
    }
    
    func addEvents(_ events: [Event]) {
        if self.events?.append(contentsOf: events) == nil {
            self.events = events
        }
    }
    
    func addSubjects(_ subjects: [Subject]) {
        if self.subjects?.append(contentsOf: subjects) == nil {
            self.subjects = subjects
        }
    }
    
    var sortedEvents: [Event] {
        guard let events else { return [] }
        return events.sorted()
    }
    
    var sortedSubjects: [Subject] {
        guard let subjects else { return [] }
        return subjects.sorted()
    }
    
    var sortVector: SortVector {
        SortVector(sortIndexes: sortedSubjects.map((\.sortIndex)))
    }
}

nonisolated extension Poem: Comparable {
    static func < (lhs: Poem, rhs: Poem) -> Bool {
        lhs.title.lowercased() < rhs.title.lowercased()
    }
}

