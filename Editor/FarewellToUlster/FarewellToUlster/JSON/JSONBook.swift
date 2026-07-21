//
//  JSONBook.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation
import SwiftData

/// For persistence the definitive data is kept in a JSON file that is imported into SwiftData when the app starts for the first time. Codable is used to parse the JSON data into an intermediate representation that can be imported. Note that the JSON data uses UUID identifiers to define relationships in the data.
final class JSONBook: Titled {
    let title: String
    let author: String
    let eras: [JSONEra]
    let events: [JSONEvent]
    let subjects: [JSONSubject]
    let poems: [JSONPoem]
    
    init(title: String, author: String, eras: [JSONEra] = [JSONEra](), events: [JSONEvent] = [JSONEvent](), subjects: [JSONSubject] = [JSONSubject](), poems: [JSONPoem] = [JSONPoem]()) {
        self.title = title
        self.author = author
        self.eras = eras
        self.events = events
        self.subjects = subjects
        self.poems = poems
    }
}

extension JSONBook: Codable {
    enum CodingKeys: String, CodingKey {
        case title, author, eras, events, subjects, poems
    }
    
    convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decode(String.self, forKey: .title)
        let author = try container.decode(String.self, forKey: .author)
        let eras = try container.decode([JSONEra].self, forKey: .eras)
        let events = try container.decode([JSONEvent].self, forKey: .events)
        let subjects = try container.decode([JSONSubject].self, forKey: .subjects)
        let poems = try container.decode([JSONPoem].self, forKey: .poems)
        self.init(title: title, author: author, eras: eras, events: events, subjects: subjects, poems: poems)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(author, forKey: .author)
        try container.encodeIfPresent(eras, forKey: .eras)
        try container.encodeIfPresent(events, forKey: .events)
        try container.encodeIfPresent(subjects, forKey: .subjects)
        try container.encodeIfPresent(poems, forKey: .poems)
    }
    
    var data: Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        do {
            let data = try encoder.encode(self)
            return data
        } catch {
            print("Failed to encode \(title)")
        }
        return Data()
    }
    
    var book: Book {
        Book(title: title, author: author)
    }
}

extension JSONBook: Equatable {
    static func == (lhs: JSONBook, rhs: JSONBook) -> Bool {
        lhs.title == rhs.title
    }
}

extension JSONBook: Comparable {
    static func < (lhs: JSONBook, rhs: JSONBook) -> Bool {
        lhs.title < rhs.title
    }
}
