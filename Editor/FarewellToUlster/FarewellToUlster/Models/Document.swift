//
//  Document.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

//TODO: Initialise with Book.

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import Synchronization
import Combine

extension UTType {
    nonisolated static var jsonBook: UTType {
        UTType(importedAs: "org.michaelthscott.json")
    }
}

final class Document: ReferenceFileDocument {
    struct DocumentStorage {
        var contents: Data
    }
    
    static let readableContentTypes: [UTType] = []
    static let writableContentTypes: [UTType] = [UTType.jsonBook, UTType.pdf]
    let storage: Mutex<DocumentStorage>

    init(data: Data) {
        self.storage = .init(.init(contents: data))
    }
    
    required init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.storage = .init(.init(contents: data))
    }
    
    func snapshot(contentType: UTType) throws -> Data {
        storage.withLock { $0.contents }
    }
    
    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: snapshot)
    }
}
