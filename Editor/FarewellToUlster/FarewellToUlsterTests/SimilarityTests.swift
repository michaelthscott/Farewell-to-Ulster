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

    @Test func testFindSimilarPoemPairs() async throws {
        let storage = try #require(Storage.testStorage(with: "SmallBook"))
        let found = PoemSimilarity(threshold: 0.0).similarPoemPairs(poems: storage.poems.sorted())
        #expect(found.count > 0)
        #expect(found.first?.poem1.title == "Rosemary")
        #expect(found.first?.poem2.title == "Sleeping leaves")
        #expect(found.last?.poem1.title == "Azure twinkles")
        #expect(found.last?.poem2.title == "Twilight")
    }

}
