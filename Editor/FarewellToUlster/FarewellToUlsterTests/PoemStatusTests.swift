//
//  PoemStatusTests.swift
//  FarewellToUlsterTests
//
//  Created by Michael Scott on 13/05/2026.
//

import Testing
@testable import FarewellToUlster

struct PoemStatusTests {

    @Test func testRawValue() async throws {
        #expect(PoemStatus(rawValue: "finished")?.rawValue == "finished")
        #expect(PoemStatus(rawValue: "undecided") == nil)
    }

}
