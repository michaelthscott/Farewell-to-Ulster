//
//  Pages.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 07/08/2026.
//

import Foundation

struct Pages {
    let storage: Storage
    
    func pages(for era: Era) -> [Page] {
        guard let book = storage.book else { return [] }
        var pages: [Page] = []
        var pageNumber: Int = 1
        pages.append(Page(type: .era(book, era), number: pageNumber))
        guard let poems = era.poems else { return pages }
        for poem in poems.vectorSorted() {
            pageNumber += 1
            pages.append(Page(type: .poem(book, era, poem), number: pageNumber))
        }
        return pages
    }
    
    var pages: [Page] {
        guard let book = storage.book else { return [] }
        var pages: [Page] = []
        var pageNumber: Int = 1
        pages.append(Page(type: .book(book), number: pageNumber))
        for era in storage.eras {
            pageNumber += 1
            pages.append(Page(type: .era(book, era), number: pageNumber))
            guard let poems = era.poems else { continue }
            for poem in poems.vectorSorted() {
                pageNumber += 1
                pages.append(Page(type: .poem(book, era, poem), number: pageNumber))
            }
        }
        return pages
    }

}
