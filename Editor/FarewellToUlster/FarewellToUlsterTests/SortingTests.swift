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
        ]
        let sortedPoems = poems.shuffled().vectorSorted()
        #expect(sortedPoems.map(\.id) == [1, 2, 4, 3, 8, 5, 7, 6])
        #expect(sortedPoems.map(\.sortVector.sortIndexes) == [[], [2], [1], [1, 2], [0], [0, 2], [0, 1], [0, 1, 2]])
    }

}
