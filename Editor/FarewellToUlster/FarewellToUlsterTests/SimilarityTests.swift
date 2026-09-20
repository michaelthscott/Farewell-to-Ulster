//
//  SimilarityTests.swift
//  FarewellToUlsterTests
//
//  Created by Michael Scott on 04/06/2026.
//

import Testing
import SwiftData
import NaturalLanguage
@testable import FarewellToUlster

struct SimilarityTests {

    @Test("Threshold: 0.0", .enabled(if: NLEmbedding.sentenceEmbedding(for: .english) != nil))
    func testFindSimilarPoemPairsZeroThreshold() async throws {
        let storage = try #require(Storage.testStorage(with: "SmallBook"))
        let found = PoemSimilarity(threshold: 0.0).similarPoemPairs(poems: storage.poems.sorted())
        #expect(found.count == 15)
        #expect(found.first?.poem1.title == "Azure twinkles")
        #expect(found.first?.poem2.title == "Twilight")
        #expect(found.last?.poem1.title == "Rosemary")
        #expect(found.last?.poem2.title == "Sleeping leaves")
    }
    
    @Test("Threshold: 0.5", .enabled(if: NLEmbedding.sentenceEmbedding(for: .english) != nil))
    func testFindSimilarPoemPairsMediumThreshold() async throws {
        let storage = try #require(Storage.testStorage(with: "SmallBook"))
        let found = PoemSimilarity(threshold: 0.5).similarPoemPairs(poems: storage.poems.sorted())
        #expect(found.count == 2)
        #expect(found.first?.poem1.title == "Azure twinkles")
        #expect(found.first?.poem2.title == "Twilight")
        #expect(found.last?.poem1.title == "Custard cake")
        #expect(found.last?.poem2.title == "Sleeping leaves")
    }

    @Test("Threshold: 0.8", .enabled(if: NLEmbedding.sentenceEmbedding(for: .english) != nil))
    func testFindSimilarPoemPairsHighThreshold() async throws {
        let storage = try #require(Storage.testStorage(with: "SmallBook"))
        let found = PoemSimilarity(threshold: 0.8).similarPoemPairs(poems: storage.poems.sorted())
        #expect(found.count == 0)
    }

}
