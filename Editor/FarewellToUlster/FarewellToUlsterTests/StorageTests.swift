//
//  StorageTests.swift
//  FarewellToUlsterTests
//
//  Created by Michael Scott on 13/05/2026.
//

import Testing
@testable import FarewellToUlster

struct StorageTests {

    @Test func testEmptyBook() throws {
        let storage = try #require(Storage.testStorage(with: "EmptyBook"))
        let book = try #require(storage.book)
        #expect(book.title == "")
        #expect(book.author == "")
        let eras = storage.eras
        #expect(eras.count == 0)
        let events = storage.events
        #expect(events.count == 0)
        let subjects = storage.subjects
        #expect(subjects.count == 0)
        let poems = storage.poems
        #expect(poems.count == 0)
    }
    
    @Test func testSmallBook() throws {
        let storage = try #require(Storage.testStorage(with: "SmallBook"))
        let book = try #require(storage.book)
        #expect(book.title == "The Blue Dawn")
        #expect(book.author == "Archibald Tumbledown")
        let eras = storage.eras
        #expect(eras.count == 3)
        let events = storage.events
        #expect(events.count == 3)
        let subjects = storage.subjects
        #expect(subjects.count == 3)
        let poems = storage.poems
        #expect(poems.count == 6)
    }

    @Test func testNoBook() throws {
        #expect(Storage.testStorage(with: "NoBook") == nil)
    }
}
