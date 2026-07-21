//
//  JSONEra.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation

/// The intermediate representation of an Era from the JSON file.
final class JSONEra {
    var fileOrder: String
    var uuid: UUID
    var title: String
    var start: String
    var end: String
    var text: String
    
    init(fileOrder: String, uuid: UUID, title: String, start: String, end: String, text: String) {
        self.fileOrder = fileOrder
        self.uuid = uuid
        self.title = title
        self.start = start
        self.end = end
        self.text = text
    }
    
    var period: DateInterval {
        let formatter = ISO8601DateFormatter()
        guard let startDate = formatter.date(from: start), let endDate = formatter.date(from: end) else {
            fatalError("Failed to get period \(start) to \(end)")
        }
        return DateInterval(start: startDate, end: endDate)
    }
    
    var era: Era {
        Era(fileOrder: fileOrder, uuid: uuid, title: title, period: period, text: text)
    }
}

extension JSONEra: Equatable {
    static func == (lhs: JSONEra, rhs: JSONEra) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

extension JSONEra: Comparable {
    static func < (lhs: JSONEra, rhs: JSONEra) -> Bool {
        lhs.fileOrder < rhs.fileOrder
    }
}

extension JSONEra: Codable {
    enum CodingKeys: String, CodingKey {
        case fileOrder, uuid, title, start, end, text
    }
    
    convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fileOrder = try container.decode(String.self, forKey: .fileOrder)
        let uuid = try container.decode(UUID.self, forKey: .uuid)
        let title = try container.decode(String.self, forKey: .title)
        let start = try container.decode(String.self, forKey: .start)
        let end = try container.decode(String.self, forKey: .end)
        let text = try container.decode(String.self, forKey: .text)
        self.init(fileOrder: fileOrder, uuid: uuid, title: title, start: start, end: end, text: text)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fileOrder, forKey: .fileOrder)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(title, forKey: .title)
        try container.encode(start, forKey: .start)
        try container.encode(end, forKey: .end)
        try container.encode(text, forKey: .text)
    }
}
