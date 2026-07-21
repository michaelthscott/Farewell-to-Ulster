//
//  PoemTests.swift
//  FarewellToUlsterTests
//
//  Created by Michael Scott on 13/05/2026.
//

import Testing
import SwiftData
import CoreData
@testable import FarewellToUlster

struct PoemTests {

    @Test func testSubjectsOrder() throws {
        let storage = try #require(Storage.testStorage(with: "SmallBook"))
        let poems = storage.poems
        let sorted = poems.vectorSorted()
        //TODO: Confirm that this is the expected result.
        #expect(sorted[0].title == "Azure twinkles")
        #expect(sorted[1].title == "Twilight")
        #expect(sorted[2].title == "Green whispers")
        #expect(sorted[3].title == "Sleeping leaves")
        #expect(sorted[4].title == "Custard cake")
        #expect(sorted[5].title == "Rosemary")
    }

    @Test func testPoemCateory() throws {
        let storage = try #require(Storage.testStorage(with: "SmallBook"))
        let uuid = try #require(UUID(uuidString: "999DFF64-E541-4591-8096-949881B8B2CB"))
        let predicate = #Predicate<Poem> { poem in
            poem.uuid == uuid
        }
        let descriptor = FetchDescriptor<Poem>(predicate: predicate)
        let poems = storage.models(for: descriptor).sorted()
        #expect(poems.count == 1)
        #expect(poems.first?.category == PoemCategory.lament)
    }

}
