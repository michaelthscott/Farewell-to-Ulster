//
//  JSONSubject.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation

/// The intermediate representation of a Subject from the JSON file.
final class JSONSubject {
    var fileOrder: String
    var uuid: UUID
    var title: String
    var category: String
    var sortIndex: Int

    init(fileOrder: String, uuid: UUID, title: String, category: String, sortIndex: Int) {
        self.fileOrder = fileOrder
        self.uuid = uuid
        self.title = title
        self.category = category
        self.sortIndex = sortIndex
    }
    
    var subject: Subject {
        Subject(fileOrder: fileOrder, uuid: uuid, title: title, category: SubjectCategory(rawValue: category), sortIndex: sortIndex)
    }
}

extension JSONSubject: Equatable {
    static func == (lhs: JSONSubject, rhs: JSONSubject) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

extension JSONSubject: Comparable {
    static func < (lhs: JSONSubject, rhs: JSONSubject) -> Bool {
        lhs.fileOrder < rhs.fileOrder
    }
}

extension JSONSubject: Codable {
    enum CodingKeys: String, CodingKey {
        case fileOrder, uuid, title, category, sortIndex
    }
    
    convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fileOrder = try container.decode(String.self, forKey: .fileOrder)
        let uuid = try container.decode(UUID.self, forKey: .uuid)
        let title = try container.decode(String.self, forKey: .title)
        let category = try container.decode(String.self, forKey: .category)
        let sortIndex = try container.decode(Int.self, forKey: .sortIndex)
        self.init(fileOrder: fileOrder, uuid: uuid, title: title, category: category, sortIndex: sortIndex)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fileOrder, forKey: .fileOrder)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(title, forKey: .title)
        try container.encode(category, forKey: .category)
        try container.encode(sortIndex, forKey: .sortIndex)
    }
}
