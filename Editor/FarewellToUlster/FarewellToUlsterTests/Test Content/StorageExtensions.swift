//
//  StorageExtensions.swift
//  FarewellToUlsterTests
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation
import SwiftData
@testable import FarewellToUlster

/// A high-level facade around the app’s SwiftData stack used in tests.
extension Storage {
    static func testStorage(with assetName: String) -> Storage? {
        guard let bundle = Bundle(identifier: "org.michaelthscott.FarewellToUlsterTests") else { return nil }
        return try? Storage(isStoredInMemoryOnly: true, assetName: assetName, bundle: bundle)
    }
    
    var book: Book? {
        let fetchDescriptor = FetchDescriptor<Book>()
        let count = modelsCount(for: fetchDescriptor)
        guard count == 1 else {
            print("Found \(count) models for \(modelName(for: fetchDescriptor))")
            return nil
        }
        let books = models(for: fetchDescriptor)
        return books.first
    }
    
    var eras: [Era] {
        models(for: FetchDescriptor<Era>()).sorted()
    }
    
    var events: [Event] {
        models(for: FetchDescriptor<Event>()).sorted()
    }
    
    var subjects: [Subject] {
        models(for: FetchDescriptor<Subject>()).sorted()
    }
    
    var poems: [Poem] {
        models(for: FetchDescriptor<Poem>()).sorted()
    }
        
    func modelsCount<T: PersistentModel>(for fetchDescriptor: FetchDescriptor<T>) -> Int {
        do {
            return try container.mainContext.fetchCount(fetchDescriptor)
        } catch {
            print("Could not fetch count \(modelName(for: fetchDescriptor))")
            return 0
        }
    }

    func models<T: PersistentModel>(for fetchDescriptor: FetchDescriptor<T>) -> [T] {
        do {
            return try container.mainContext.fetch(fetchDescriptor)
        } catch {
            print("Could not fetch \(modelName(for: fetchDescriptor))")
            return []
        }
    }
    
    func modelName<T: PersistentModel>(for fetchDescriptor: FetchDescriptor<T>) -> String {
        let regex = /FetchDescriptor<(.+?)>\(/
        let description = "\(fetchDescriptor)"
        if let match = description.firstMatch(of: regex) {
            return String(match.1)
        }
        return "Unknown"
    }
}
