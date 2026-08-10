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
    var id: Int
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
        let subjects = [MockSubject(id: 1, sortIndex: 0), MockSubject(id: 2, sortIndex: 1), MockSubject(id: 3, sortIndex: 2)]
        
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

    // TODO: This will need to be updated if we make reindexing a consequence of subject deletion.
    @Test func testDeleteSubject() async throws {
        let storage = try #require(Storage.testStorage(with: "SmallBook"))
        #expect(storage.subjects.count == 3)
        #expect(storage.subjects.indexSorted().map { "\($0.title):\($0.sortIndex)"} == ["Thinking:0", "The Horizon:1", "Pussycat:2"])
        #expect(storage.subjects[1].title == "The Horizon")
        storage.delete(storage.subjects[1])
        #expect(storage.subjects.count == 2)
        #expect(storage.subjects.indexSorted().map { "\($0.title):\($0.sortIndex)"} == ["Thinking:0", "Pussycat:2"])
        try? storage.reindexSubjects()
        #expect(storage.subjects.indexSorted().map { "\($0.title):\($0.sortIndex)"} == ["Thinking:0", "Pussycat:1"])
    }
}
