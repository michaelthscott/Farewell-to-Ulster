//
//  SubjectCategory.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation

/// Subjects are grouped into a number categories.
enum SubjectCategory: String {
    case activity
    case animal
    case feeling
    case person
    case place
    case thing
}

extension SubjectCategory: CaseIterable {}

extension SubjectCategory: Codable {}

extension SubjectCategory: Identifiable {
    var id: String {
        rawValue
    }
}
