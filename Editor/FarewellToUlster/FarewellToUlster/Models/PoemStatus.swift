//
//  PoemStatus.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation

/// The progress of a poem to completion.
enum PoemStatus: String {
    case undevelopedIdea = "undeveloped idea"
    case gettingStarted = "getting started"
    case inProgress = "in progress"
    case almostFinished = "almost finished"
    case finished = "finished"
    case duplicate = "duplicate"
}

extension PoemStatus: Codable {}

extension PoemStatus: CaseIterable {}

extension PoemStatus: Identifiable {
    var id: String {
        rawValue
    }
}
