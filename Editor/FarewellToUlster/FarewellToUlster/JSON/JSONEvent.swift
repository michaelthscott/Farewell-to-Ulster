//
//  JSONEvent.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation

/// The intermediate representation of an Event from the JSON file.
final class JSONEvent {
    var fileOrder: String
    var uuid: UUID
    var title: String
    var date: String
    
    init(fileOrder: String, uuid: UUID, title: String, date: String) {
        self.fileOrder = fileOrder
        self.uuid = uuid
        self.title = title
        self.date = date
    }
    
    var period: DateInterval {
        let formatter = ISO8601DateFormatter()
        guard let startDate = formatter.date(from: date) else {
            fatalError("Failed to get date")
        }
        return DateInterval(start: startDate, duration: 0)
    }
    
    var event: Event {
        Event(fileOrder: fileOrder, uuid: uuid, title: title, period: period)
    }
}

extension JSONEvent: Equatable {
    static func == (lhs: JSONEvent, rhs: JSONEvent) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

extension JSONEvent: Comparable {
    static func < (lhs: JSONEvent, rhs: JSONEvent) -> Bool {
        lhs.fileOrder < rhs.fileOrder
    }
}

extension JSONEvent: Codable {
    enum CodingKeys: String, CodingKey {
        case fileOrder, uuid, title, date
    }
    
    convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fileOrder = try container.decode(String.self, forKey: .fileOrder)
        let uuid = try container.decode(UUID.self, forKey: .uuid)
        let title = try container.decode(String.self, forKey: .title)
        let date = try container.decode(String.self, forKey: .date)
        self.init(fileOrder: fileOrder, uuid: uuid, title: title, date: date)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fileOrder, forKey: .fileOrder)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(title, forKey: .title)
        try container.encode(date, forKey: .date)
    }
}
