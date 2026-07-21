//
//  Sorting.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation
import SwiftData

/// Protocol used to position subjects in a sort vector.
nonisolated protocol SortIndexable {
    var sortIndex: Int { get set }
}

/// Protocol used to sort poems by subject sort vectors.
nonisolated protocol SortOrderable {
    var sortVector: SortVector { get }
}

/// Extension on Collection for SortIndexable Elements.
extension Collection where Element: SortIndexable {
    /// Iterate through the collection and set the sortIndex to the index of the element in the collection.
    func resetSortIndexes() {
        for (index, var item) in enumerated() {
            if item.sortIndex == index { continue }
            item.sortIndex = index
        }
    }
}

extension Collection where Element: SortOrderable {
    func vectorSorted() -> [Element] {
        sorted(by: { $0.sortVector < $1.sortVector })
    }
}

/// Error that can be encountered while sorting the subjects.
enum SortingError: Error, CustomStringConvertible {
    case reindexFailed

    var description: String {
        switch self {
        case .reindexFailed: return "Resetting sort indices failed"
        }
    }
}

extension ModelContext {
    /// Re-index the subjects so that their sortIndex property correctly indicates their position in the sorted array of subjects.
    func reindexSubjects() throws {
        let fetchDescriptor = FetchDescriptor<Subject>()
        do {
            let items = try fetch(fetchDescriptor).sorted(by: { $0.sortIndex < $1.sortIndex })
            items.resetSortIndexes()
        } catch {
            throw SortingError.reindexFailed
        }
        if hasChanges {
            try save()
        }
    }
}
