//
//  SimilarityTests.swift
//  FarewellToUlsterTests
//
//  Created by Michael Scott on 04/06/2026.
//

import Testing
import SwiftData
@testable import FarewellToUlster

struct SimilarityTests {

    @Test func testFindSimilarPoemPairsZeroThreshold() async throws {
        let storage = try #require(Storage.testStorage(with: "SmallBook"))
        let found = PoemSimilarity(threshold: 0.0).similarPoemPairs(poems: storage.poems.sorted())
        #expect(found.count == 15)
        #expect(found.first?.poem1.title == "Azure twinkles")
        #expect(found.first?.poem2.title == "Twilight")
        #expect(found.last?.poem1.title == "Rosemary")
        #expect(found.last?.poem2.title == "Sleeping leaves")
    }
    
    @Test func testFindSimilarPoemPairsMediumThreshold() async throws {
        let storage = try #require(Storage.testStorage(with: "SmallBook"))
        let found = PoemSimilarity(threshold: 0.5).similarPoemPairs(poems: storage.poems.sorted())
        #expect(found.count == 2)
        #expect(found.first?.poem1.title == "Azure twinkles")
        #expect(found.first?.poem2.title == "Twilight")
        #expect(found.last?.poem1.title == "Custard cake")
        #expect(found.last?.poem2.title == "Sleeping leaves")
    }

    @Test func testFindSimilarPoemPairsHighThreshold() async throws {
        let storage = try #require(Storage.testStorage(with: "SmallBook"))
        let found = PoemSimilarity(threshold: 0.8).similarPoemPairs(poems: storage.poems.sorted())
        #expect(found.count == 0)
    }

}
