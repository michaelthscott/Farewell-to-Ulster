//
//  Era.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation
import SwiftData

/// An event is a long period associated with a number of poems.
@Model
nonisolated final class Era: Titled, FileOrdered {
    var fileOrder: String
    var uuid: UUID
    var title: String
    var period: DateInterval
    var text: String
    var poems: [Poem]?
    
    init(fileOrder: String = "0000", uuid: UUID = UUID(), title: String = "Untitled", period: DateInterval = DateInterval(), text: String = "", poems: [Poem]? = nil) {
        self.fileOrder = fileOrder
        self.uuid = uuid
        self.title = title
        self.period = period
        self.text = text
        self.poems = poems
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

nonisolated extension Era: Comparable {
    static func < (lhs: Era, rhs: Era) -> Bool {
        lhs.period.start < rhs.period.start
    }
}

