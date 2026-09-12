//
//  MDType.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 12/09/2026.
//

import Foundation

enum MDType: String, Codable {
    case none
    case era
    case poem
    
    var path: String {
        switch self {
        case .none: return "/"
        case .era: return "/Eras/"
        case .poem: return "/Poems/"
        }
    }
}
