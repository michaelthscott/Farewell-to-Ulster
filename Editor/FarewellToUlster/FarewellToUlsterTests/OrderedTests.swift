//
//  OrderedTests.swift
//  FarewellToUlsterTests
//
//  Created by Michael Scott on 13/05/2026.
//

import Testing
import SwiftData
import UIKit
@testable import FarewellToUlster

class OrderedTests {
    let fetchDescriptor = FetchDescriptor<Poem>(sortBy: [.init(\Poem.fileOrder)])

    @Test func testInsertOrderedWithoutDelete() async throws {
        let storage = try #require(Storage.testStorage(with: "SmallBook"))
        let originalCount = try storage.container.mainContext.fetchCount(fetchDescriptor)
        #expect(originalCount ==  6)
        let newPoem = Poem()
        try storage.container.mainContext.insertOrdered(newPoem)
        let newCount = try storage.container.mainContext.fetchCount(fetchDescriptor)
        #expect(newCount ==  7)
        #expect(throws: Never.self) {
            let poems = try storage.container.mainContext.fetch(self.fetchDescriptor)
            #expect(poems.first?.fileOrder == "0001")
            #expect(poems.last?.fileOrder == "0007")
        }
    }
    
    @Test func testInsertOrderedAfterDelete() async throws {
        #expect(throws: Never.self) {
            let storage = try #require(Storage.testStorage(with: "SmallBook"))
            var poems = try storage.container.mainContext.fetch(fetchDescriptor)
            storage.container.mainContext.delete(poems[0])
            try storage.container.mainContext.save()
            let originalCount = try storage.container.mainContext.fetchCount(fetchDescriptor)
            #expect(originalCount == 5)
            let newPoem = Poem()
            try storage.container.mainContext.insertOrdered(newPoem)
            let newCount = try storage.container.mainContext.fetchCount(fetchDescriptor)
            #expect(newCount ==  6)
            poems = try storage.container.mainContext.fetch(fetchDescriptor)
            #expect(poems.first?.fileOrder == "0002")
            #expect(poems.last?.fileOrder == "0007")
        }
    }
    
    @Test func testInsertOrderedAlreadyExists() async throws {
        let storage = try #require(Storage.testStorage(with: "SmallBook"))
        #expect(throws: FileOrderedError.alreadyExists) {
            let poems = try storage.container.mainContext.fetch(fetchDescriptor)
            try storage.container.mainContext.insertOrdered(poems[0])
        }
    }
    
    @Test func testInsertOrderedFirstInsert() async throws {
        let storage = try #require(Storage.testStorage(with: "SmallBook"))
        let poems = try storage.container.mainContext.fetch(fetchDescriptor)
        for poem in poems {
            storage.container.mainContext.delete(poem)
        }
        let newPoem = Poem()
        #expect(throws: Never.self) {
            try storage.container.mainContext.insertOrdered(newPoem)
        }
        #expect(newPoem.fileOrder == "0001")
    }
}
