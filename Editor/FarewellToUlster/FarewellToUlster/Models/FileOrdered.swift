//
//  FileOrdered.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation
import SwiftData

/// In order to make the minimum changes to the persistent JSON file, the models have a fileOrder property that does not change. When a new model is added it is given the next available value.
nonisolated protocol FileOrdered: PersistentModel {
    var fileOrder: String { get set }
}

/// An error that can be encountered while inserting a model.
enum FileOrderedError: Error, CustomStringConvertible {
    case alreadyExists
    case parseFailed
    case insertFailed
    
    var description: String {
        switch self {
        case .alreadyExists: return "Already exists"
        case .parseFailed: return "Parse failed"
        case .insertFailed: return "Insert failed"
        }
    }
}

// ErasTab, EventsTab, SubjectsTab and PoemsTab all call modelContext.insertOrdered(newEra)
extension Storage {
    func insertOrdered<T: FileOrdered>(_ model: T) throws {
        let identifier = model.persistentModelID
        let existing: T? = container.mainContext.registeredModel(for: identifier)
        guard existing == nil else {
            throw FileOrderedError.alreadyExists
        }
        let fetchDescriptor = FetchDescriptor<T>()
        do {
            if let last = try container.mainContext.fetch(fetchDescriptor).sorted(by: { $0.fileOrder < $1.fileOrder }).last {
                if let number = Int(last.fileOrder) {
                    model.fileOrder = String(format: "%04d", number + 1)
                } else {
                    throw FileOrderedError.parseFailed
                }
            } else {
                model.fileOrder = "0001"
            }
            container.mainContext.insert(model)
            if container.mainContext.hasChanges {
                try container.mainContext.save()
            }
        } catch {
            throw FileOrderedError.insertFailed
        }
    }
}
