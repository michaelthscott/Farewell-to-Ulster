//
//  Page.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation

/// The types of pages in the printable version of the book.
enum PageType: Hashable {
    case empty
    case book(Book)
    case era(Book, Era)
    case poem(Book, Era, Poem)
}

/// A page of the book.
struct Page: Identifiable, Hashable {
    static func == (lhs: Page, rhs: Page) -> Bool {
        lhs.number == rhs.number
    }
    
    let type: PageType
    let number: Int
    var id: Int { number }
}
