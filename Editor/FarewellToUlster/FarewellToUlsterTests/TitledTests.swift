//
//  TitledTests.swift
//  FarewellToUlsterTests
//
//  Created by Michael Scott on 13/05/2026.
//

import Testing
@testable import FarewellToUlster

struct TitledTests {

    @Test func testLowercaseTitle() async throws {
        struct Test: Titled {
            var title: String { "Test" }
        }
        
        let test = Test()
        #expect(test.title == "Test")
    }

}
