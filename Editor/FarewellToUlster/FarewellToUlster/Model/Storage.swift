//
//  Storage.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation
import SwiftData
import UIKit

enum StorageError: Error {
    case invalidAsset
    case noModelContainer
}

/// SwiftData storage that is initialised from JSON data.
final class Storage {
    let container: ModelContainer
    
    init(isStoredInMemoryOnly: Bool = false, assetName: String = "Farewell_to_Ulster", bundle: Bundle = Bundle.main) throws {
        let schema = Schema([
            Book.self,
            Era.self,
            Event.self,
            Subject.self,
            Poem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isStoredInMemoryOnly)
        do {
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            throw StorageError.noModelContainer
        }
        do {
            try loadData(assetName: assetName, bundle: bundle)
        } catch {
            throw StorageError.invalidAsset
        }
    }
    
    func loadData(assetName: String, bundle: Bundle = Bundle.main) throws {
        let descriptor = FetchDescriptor<Book>()
        let booksCount = try container.mainContext.fetchCount(descriptor)
        guard booksCount == 0 else { return }
        guard let asset = NSDataAsset(name: assetName, bundle: bundle) else { throw StorageError.invalidAsset }
        let jsonBook = try JSONDecoder().decode(JSONBook.self, from: asset.data)
        
        let book = jsonBook.book
        container.mainContext.insert(book)

        for jsonEra in jsonBook.eras {
            let era = jsonEra.era
            container.mainContext.insert(era)
        }
        
        for jsonEvent in jsonBook.events {
            let event = jsonEvent.event
            container.mainContext.insert(event)
        }
        
        for jsonSubject in jsonBook.subjects {
            let subject = jsonSubject.subject
            container.mainContext.insert(subject)
        }
        
        for jsonPoem in jsonBook.poems {
            let poem = jsonPoem.poem
            if let eraUUID = jsonPoem.eraUUID {
                let fetchDescriptor = FetchDescriptor<Era>(predicate: #Predicate{ era in
                    era.uuid == eraUUID
                })
                poem.era = try? container.mainContext.fetch(fetchDescriptor).first
            }
            if let eventUUIDs = jsonPoem.eventUUIDs, !eventUUIDs.isEmpty {
                var events: [Event] = []
                for eventUUID in eventUUIDs {
                    let fetchDescriptor = FetchDescriptor<Event>(predicate: #Predicate{ event in
                        event.uuid == eventUUID
                    })
                    if let event = try? container.mainContext.fetch(fetchDescriptor).first {
                        if !events.contains(event) {
                            events.append(event)
                        }
                    }
                }
                poem.events = events
            }
            if let subjectUUIDs = jsonPoem.subjectUUIDs, !subjectUUIDs.isEmpty {
                var subjects: [Subject] = []
                for subjectUUID in subjectUUIDs {
                    let fetchDescriptor = FetchDescriptor<Subject>(predicate: #Predicate{ subject in
                        subject.uuid == subjectUUID
                    })
                    if let subject = try? container.mainContext.fetch(fetchDescriptor).first {
                        if !subjects.contains(subject) {
                            subjects.append(subject)
                        }
                    }
                }
                poem.subjects = subjects
            }
            container.mainContext.insert(poem)
        }
    }
}
