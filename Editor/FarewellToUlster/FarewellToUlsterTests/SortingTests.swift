//
//  SortingTests.swift
//  FarewellToUlsterTests
//
//  Created by Michael Scott on 13/05/2026.
//

import Testing
import Foundation
@testable import FarewellToUlster

struct MockSubject: SortIndexable {
    var sortIndex: Int
}

struct MockPoem: SortOrderable & Identifiable & Equatable {
    static func == (lhs: MockPoem, rhs: MockPoem) -> Bool {
        lhs.id == rhs.id
    }
    var id: Int
    var sortVector: SortVector
}

struct SortingTests {

    @Test func testSort() async throws {
        let subjects = [MockSubject(sortIndex: 0), MockSubject(sortIndex: 1), MockSubject(sortIndex: 2)]
        
        let poems = [
            MockPoem(id: 1, sortVector: SortVector(sortIndexes: [])),
            MockPoem(id: 2, sortVector: SortVector(sortIndexes: [subjects[2]].map(\.sortIndex))),
            MockPoem(id: 3, sortVector: SortVector(sortIndexes: [subjects[1], subjects[2]].map(\.sortIndex))),
            MockPoem(id: 4, sortVector: SortVector(sortIndexes: [subjects[1]].map(\.sortIndex))),
            MockPoem(id: 5, sortVector: SortVector(sortIndexes: [subjects[0], subjects[2]].map(\.sortIndex))),
            MockPoem(id: 6, sortVector: SortVector(sortIndexes: [subjects[0], subjects[1], subjects[2]].map(\.sortIndex))),
            MockPoem(id: 7, sortVector: SortVector(sortIndexes: [subjects[0], subjects[1]].map(\.sortIndex))),
            MockPoem(id: 8, sortVector: SortVector(sortIndexes: [subjects[0]].map(\.sortIndex)))
        ].shuffled()
        
        let sortedPoems = poems.vectorSorted()
        // TODO: Is this what we want when sorting poems by their associated subjects?
        #expect(sortedPoems.map(\.sortVector.string) == ["", "001", "01", "011", "1", "101", "11", "111"])
    }

}
