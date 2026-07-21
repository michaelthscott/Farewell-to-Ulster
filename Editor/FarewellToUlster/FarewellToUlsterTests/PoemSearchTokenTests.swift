//
//  PoemSearchTokenTests.swift
//  FarewellToUlsterTests
//
//  Created by Michael Scott on 13/05/2026.
//

import Testing
@testable import FarewellToUlster

//uncategorised
//case noSubjects
//case duplicateTitle
//case firstLineTitle

struct PoemSearchTokenTests {

    @Test func testAllCases() async throws {
        #expect(PoemSearchToken.allCases == [.status(.undevelopedIdea), .status(.gettingStarted), .status(.inProgress), .status(.almostFinished), .status(.finished), .status(.duplicate),
                                             .category(.complaint), .category(.descriptive), .category(.ironic), .category(.lament), .category(.lyric), .category(.narrative),
                                             .uncategorised, .noSubjects, .duplicateTitle, .firstLineTitle])
    }

    @Test func testRawValue() async throws {
        #expect(PoemSearchToken(rawValue: "") == nil)
        #expect(PoemSearchToken(rawValue: "duplicate title") == .duplicateTitle)
        #expect(PoemSearchToken(rawValue: PoemStatus.undevelopedIdea.rawValue) == PoemSearchToken.status(.undevelopedIdea))
        #expect(PoemSearchToken(rawValue: PoemCategory.narrative.rawValue) == PoemSearchToken.category(.narrative))
    }
}
