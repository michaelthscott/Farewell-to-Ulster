//
//  Previewer.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation
import SwiftData

/// Data storage for previews.
struct Previewer {
    let storage = try! Storage(isStoredInMemoryOnly: true, assetName: "SampleData")

    var book: Book? {
        let descriptor = FetchDescriptor<Book>()
        let books = try? storage.container.mainContext.fetch(descriptor)
        return books?.first
    }
    
    var era: Era? {
        let descriptor = FetchDescriptor<Era>()
        let eras = try? storage.container.mainContext.fetch(descriptor)
        return eras?.sorted().first
    }

    var event: Event? {
        let descriptor = FetchDescriptor<Event>()
        let events = try? storage.container.mainContext.fetch(descriptor)
        return events?.sorted().first
    }

    var subject: Subject? {
        let descriptor = FetchDescriptor<Subject>()
        let subjects = try? storage.container.mainContext.fetch(descriptor)
        return subjects?.sorted().first
    }

    var poem: Poem? {
        let descriptor = FetchDescriptor<Poem>()
        let poems = try? storage.container.mainContext.fetch(descriptor)
        return poems?.sorted().first
    }

    var subjects: [Subject] {
        let descriptor = FetchDescriptor<Subject>()
        guard let subjects = try? storage.container.mainContext.fetch(descriptor) else { return [Subject]() }
        return subjects.sorted()
    }
    
    func subjects(count: Int) -> [Subject] {
        var array = [Subject]()
        for i in 0..<count {
            array.append(Subject(title: "Subject " + String(format: "%02d", i)))
        }
        return array
    }
    
    var eras: [Era] {
        let descriptor = FetchDescriptor<Era>()
        guard let eras = try? storage.container.mainContext.fetch(descriptor) else { return [Era]() }
        return eras.sorted()
    }
    
    var poems: [Poem] {
        let descriptor = FetchDescriptor<Poem>()
        guard let poems = try? storage.container.mainContext.fetch(descriptor) else { return [Poem]() }
        return poems.sorted()
    }
}
