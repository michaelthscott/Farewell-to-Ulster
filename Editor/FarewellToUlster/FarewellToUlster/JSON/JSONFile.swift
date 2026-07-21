//
//  JSONFile.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation
import SwiftData
import UniformTypeIdentifiers

struct JSONFile {
    let jsonBook: JSONBook
    
    init?(modelContext: ModelContext) {
        guard let books = try? modelContext.fetch(FetchDescriptor<Book>()),
              let book = books.first,
              let eras = try? modelContext.fetch(FetchDescriptor<Era>()),
              let events = try? modelContext.fetch(FetchDescriptor<Event>()),
              let subjects = try? modelContext.fetch(FetchDescriptor<Subject>()),
              let poems = try? modelContext.fetch(FetchDescriptor<Poem>()) else {
            return nil
        }
        self.init(book: book, eras: eras, events: events, subjects: subjects, poems: poems)
    }
    
    init(book: Book, eras: [Era], events: [Event], subjects: [Subject], poems: [Poem]) {
        let sortedEras = eras.map { era in
            let formatter = ISO8601DateFormatter()
            return JSONEra(fileOrder: era.fileOrder, uuid: era.uuid, title: era.title, start: formatter.string(from: era.period.start), end: formatter.string(from: era.period.end), text: era.text)
        }.sorted()
        let sortedEvents = events.map { event in
            let formatter = ISO8601DateFormatter()
            return JSONEvent(fileOrder: event.fileOrder, uuid: event.uuid, title: event.title, date: formatter.string(from: event.period.start))
        }.sorted()
        let sortedSubjects = subjects.map { subject in
            JSONSubject(fileOrder: subject.fileOrder, uuid: subject.uuid, title: subject.title, category: subject.category?.rawValue ?? "undefined", sortIndex: subject.sortIndex)
        }.sorted()
        let sortedPoems = poems.map { poem in
            let jsonPoem = JSONPoem(fileOrder: poem.fileOrder, uuid: poem.uuid, title: poem.title, text: poem.text)
            if !poem.scratchpad.isEmpty {
                jsonPoem.scratchpad = poem.scratchpad
            }
            if let status = poem.status {
                jsonPoem.status = status.rawValue
            }
            if let category = poem.category {
                jsonPoem.category = category.rawValue
            }
            if let era = poem.era {
                jsonPoem.eraUUID = era.uuid
            }
            if let events = poem.events, !events.isEmpty {
                jsonPoem.eventUUIDs = events.map(\.uuid).sorted()
            }
            if let subjects = poem.subjects, !subjects.isEmpty {
                jsonPoem.subjectUUIDs = subjects.map(\.uuid).sorted()
            }
            return jsonPoem
        }.sorted()
        jsonBook = JSONBook(title: book.title, author: book.author, eras: sortedEras, events: sortedEvents, subjects: sortedSubjects, poems: sortedPoems)
    }
    
    var document: Document {
        Document(data: jsonBook.data)
    }
    
    var contentType: UTType {
        .jsonBook
    }
    
    var fileName: String {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: .now)
        let year = String(format: "%04d", components.year ?? 0)
        let month = String(format: "%02d", components.month ?? 0)
        let day = String(format: "%02d", components.day ?? 0)
        let hours = String(format: "%02d", components.hour ?? 0)
        let minutes = String(format: "%02d", components.minute ?? 0)
        let seconds = String(format: "%02d", components.second ?? 0)
        return "\(year)-\(month)-\(day)_\(hours)-\(minutes)-\(seconds).json"
    }
}
