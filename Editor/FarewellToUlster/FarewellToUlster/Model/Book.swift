//
//  Book.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation
import SwiftData

/// The book's title and author.
@Model
nonisolated final class Book: Titled {
    var title: String
    var author: String
    
    init(title: String = "Untitled", author: String = "Anonymous") {
        self.title = title
        self.author = author
    }
}
