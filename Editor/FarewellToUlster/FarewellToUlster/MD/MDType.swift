//
//  MDType.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 12/09/2026.
//

import Foundation

enum MDType: String, Codable {
    case none
    case site
    case era
    case poem
    
    var path: String {
        switch self {
        case .none: return ""
        case .site: return "/Farewell-to-Ulster/"
        case .era: return "/Farewell-to-Ulster/Eras/"
        case .poem: return "/Farewell-to-Ulster/Poems/"
        }
    }
}
