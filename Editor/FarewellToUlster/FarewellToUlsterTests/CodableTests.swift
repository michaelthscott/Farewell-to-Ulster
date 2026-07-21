//
//  CodableTests.swift
//  FarewellToUlsterTests
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation
import Testing
@testable import FarewellToUlster
import UIKit

struct CodableTests {
    enum TestError: Error {
        case invalidAsset
    }
    
    @Test func testImportJSON() async throws {
        guard let asset = NSDataAsset(name: "Farewell-to-Ulster") else { throw TestError.invalidAsset }
        let data = asset.data
        let book = try JSONDecoder().decode(JSONBook.self, from: data)
        #expect(book.title == "Farewell to Ulster")
        #expect(book.author == "Michael T. H. Scott")
        #expect(book.eras.count > 0)
        #expect(book.events.count > 0)
        #expect(book.subjects.count > 0)
        #expect(book.poems.count > 0)
    }

    @Test func testExportJSON() async throws {
        guard let asset = NSDataAsset(name: "Farewell-to-Ulster") else { throw TestError.invalidAsset }
        let data1 = asset.data
        let book1 = try JSONDecoder().decode(JSONBook.self, from: data1)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data2 = try encoder.encode(book1)
        let book2 = try JSONDecoder().decode(JSONBook.self, from: data2)
        #expect(book1 == book2)
        let string1 = String(decoding: data1, as: Unicode.UTF8.self)
        let string2 = String(decoding: data2, as: Unicode.UTF8.self)
        let newString1 = string1.replacingOccurrences(of: "\n\n", with: "\n")
        let newString2 = string2.replacingOccurrences(of: "\n\n", with: "\n")
        #expect(abs(newString1.count - newString2.count) <= 1)
    }
}

