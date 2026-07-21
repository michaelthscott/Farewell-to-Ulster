//
//  Subject.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation
import SwiftData

/// A subject that is associated with a number of poems.
@Model
nonisolated final class Subject: Titled, FileOrdered, SortIndexable {
    var fileOrder: String
    var uuid: UUID
    var title: String
    var category: SubjectCategory?
    var poems: [Poem]?
    var sortIndex: Int
    
    init(fileOrder: String = "9999", uuid: UUID = UUID(), title: String = "Untitled", category: SubjectCategory? = nil, poems: [Poem]? = nil, sortIndex: Int = 999) {
        self.fileOrder = fileOrder
        self.uuid = uuid
        self.title = title
        self.category = category
        self.poems = poems
        self.sortIndex = sortIndex
    }
    
    func addPoem(_ poem: Poem) {
        if poems?.append(poem) == nil {
            poems = [poem]
        }
    }
    
    var poemsCount: Int {
        guard let poems else { return 0 }
        return poems.count
    }
}

nonisolated extension Subject: Comparable {
    static func < (lhs: Subject, rhs: Subject) -> Bool {
        lhs.title.lowercased() < rhs.title.lowercased()
    }
}
