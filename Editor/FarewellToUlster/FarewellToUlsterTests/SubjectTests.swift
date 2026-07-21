//
//  SubjectTests.swift
//  FarewellToUlsterTests
//
//  Created by Michael Scott on 13/05/2026.
//

import Testing
@testable import FarewellToUlster

struct SubjectTests {

    @Test func testSortIndex() throws {
        let storage = try #require(Storage.testStorage(with: "SmallBook"))
        let subjects = storage.subjects.sorted(by: { $0.fileOrder < $1.fileOrder })
        #expect(subjects[0].fileOrder == "0001")
        #expect(subjects[0].sortIndex == 0)
        #expect(subjects[1].sortIndex == 1)
    }

}
