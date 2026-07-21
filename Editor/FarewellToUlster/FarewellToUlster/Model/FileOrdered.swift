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

extension ModelContext {
    func insertOrdered<T: FileOrdered>(_ model: T) throws {
        let identifier = model.persistentModelID
        let existing: T? = registeredModel(for: identifier)
        guard existing == nil else {
            throw FileOrderedError.alreadyExists
        }
        let fetchDescriptor = FetchDescriptor<T>()
        do {
            if let last = try fetch(fetchDescriptor).sorted(by: { $0.fileOrder < $1.fileOrder }).last {
                if let number = Int(last.fileOrder) {
                    model.fileOrder = String(format: "%04d", number + 1)
                } else {
                    throw FileOrderedError.parseFailed
                }
            } else {
                model.fileOrder = "0001"
            }
            insert(model)
            if hasChanges {
                try save()
            }
        } catch {
            throw FileOrderedError.insertFailed
        }
    }
}
