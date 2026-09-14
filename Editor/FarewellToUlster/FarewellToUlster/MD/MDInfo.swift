//
//  MDInfo.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 12/09/2026.
//

import Foundation

struct MDInfo: Equatable {
    static let none = MDInfo()
    static let site = MDInfo(type: .site, title: "Farewell to Ulster")
    static func era(title: String, number: String) -> MDInfo {
        MDInfo(type: .era, title: title, number: number)
    }
    static func poem(title: String, number: String) -> MDInfo {
        MDInfo(type: .poem, title: title, number: number)
    }
    
    let type: MDType
    let title: String
    let number: String
    
    init(type: MDType = .none, title: String = "", number: String = "") {
        self.type = type
        self.title = title
        self.number = number
    }
}
