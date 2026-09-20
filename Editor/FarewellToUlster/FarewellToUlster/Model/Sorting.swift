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
    func indexSorted() -> [Element] {
        sorted(by: { $0.sortIndex < $1.sortIndex })
    }
    
    /*
     TODO: resetSortIndexes has a real bug: as written, it can never actually update the elements unless Element is a class. enumerated() produces (offset, element) pairs by value. var item copies that element into a local variable; mutating item.sortIndex mutates the copy, not anything reachable through the collection. And since this is declared on Collection (not MutableCollection), there's no subscript setter available even if you wanted one — the method has no way to write back. For a struct Element, this method silently does nothing observable to the caller, despite its name and doc comment ("set the sortIndex to the index of the element in the collection") implying persistence.
    
    It only "works" if Element is a class — then item is a reference and mutating item.sortIndex does affect the shared instance. That's a fragile, implicit dependency on reference semantics that nothing in the code signals.

    To make it actually do what it says, you'd need either:

    extension MutableCollection where Element: SortIndexable {
        mutating func resetSortIndexes() {
            for i in indices {
                if self[i].sortIndex != self[i].distance(from: startIndex, to: i) { /* ... */ }
            }
        }
    }

    (roughly — needs Index == Int or an offset calculation for non-Int-indexed collections), or, if Element is meant to stay a class, at minimum a comment noting the reference-semantics requirement so it isn't silently broken if someone converts the type to a struct later.
    */
    
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

extension Storage {
    // TODO:  Called from EditorDelete's post-delete action in SubjectEditor after deleting the subject. Should deleting one of more subjects automatically run this? The problem is that we want EditorDelete to work for all models, but then also handle the special case for subjects. Thus the post-delete action.
    
    /// Re-index the subjects so that their sortIndex property correctly indicates their position in the sorted array of subjects.
    func reindexSubjects() throws {
        let fetchDescriptor = FetchDescriptor<Subject>()
        do {
            let items = try container.mainContext.fetch(fetchDescriptor).sorted(by: { $0.sortIndex < $1.sortIndex })
            items.resetSortIndexes()
        } catch {
            throw SortingError.reindexFailed
        }
        if container.mainContext.hasChanges {
            try container.mainContext.save()
        }
    }
}
