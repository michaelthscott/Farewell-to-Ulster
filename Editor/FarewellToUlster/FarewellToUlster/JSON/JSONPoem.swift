//
//  JSONPoem.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation

/// The intermediate representation of the Poem from the JSON file.
final class JSONPoem {
    var fileOrder: String
    var uuid: UUID
    var title: String
    var text: String
    var scratchpad: String?
    var status: String?
    var category: String?
    var eraUUID: UUID?
    var eventUUIDs: [UUID]?
    var subjectUUIDs: [UUID]?
    
    init(fileOrder: String, uuid: UUID, title: String, text: String, scratchpad: String? = nil, status: String? = nil, category: String? = nil, eraUUID: UUID? = nil, eventUUIDs: [UUID]? = nil, subjectUUIDs: [UUID]? = nil) {
        self.fileOrder = fileOrder
        self.uuid = uuid
        self.title = title
        self.text = text
        self.scratchpad = scratchpad
        self.status = status
        self.category = category
        self.eraUUID = eraUUID
        self.eventUUIDs = eventUUIDs
        self.subjectUUIDs = subjectUUIDs
    }
    
    var poem: Poem {
        let poem = Poem(fileOrder: fileOrder, uuid: uuid, title: title, text: text)
        if let scratchpad {
            poem.scratchpad = scratchpad
        }
        if let status {
            poem.status = PoemStatus(rawValue: status)
        }
        if let category {
            poem.category = PoemCategory(rawValue: category)
        }
        return poem
    }
}

extension JSONPoem: Equatable {
    static func == (lhs: JSONPoem, rhs: JSONPoem) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

extension JSONPoem: Comparable {
    static func < (lhs: JSONPoem, rhs: JSONPoem) -> Bool {
        lhs.fileOrder < rhs.fileOrder
    }
}

extension JSONPoem: Codable {
    enum CodingKeys: String, CodingKey {
        case fileOrder, uuid, title, text, scratchpad, status, category, eraUUID, eventUUIDs, subjectUUIDs
    }
    
    convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fileOrder = try container.decode(String.self, forKey: .fileOrder)
        let uuid = try container.decode(UUID.self, forKey: .uuid)
        let title = try container.decode(String.self, forKey: .title)
        let text = try container.decode(String.self, forKey: .text)
        let scratchpad = try container.decodeIfPresent(String.self, forKey: .scratchpad)
        let status = try container.decodeIfPresent(String.self, forKey: .status)
        let category = try container.decodeIfPresent(String.self, forKey: .category)
        let eraUUID = try container.decodeIfPresent(UUID.self, forKey: .eraUUID)
        let eventUUIDs = try container.decodeIfPresent([UUID].self, forKey: .eventUUIDs)
        let subjectUUIDs = try container.decodeIfPresent([UUID].self, forKey: .subjectUUIDs)
        self.init(fileOrder: fileOrder, uuid: uuid, title: title, text: text, scratchpad: scratchpad, status: status, category: category, eraUUID: eraUUID, eventUUIDs: eventUUIDs, subjectUUIDs: subjectUUIDs)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fileOrder, forKey: .fileOrder)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(title, forKey: .title)
        try container.encode(text, forKey: .text)
        try container.encodeIfPresent(scratchpad, forKey: .scratchpad)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(eraUUID, forKey: .eraUUID)
        try container.encodeIfPresent(eventUUIDs, forKey: .eventUUIDs)
        try container.encodeIfPresent(subjectUUIDs, forKey: .subjectUUIDs)
    }
}
