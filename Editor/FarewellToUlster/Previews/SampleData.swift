//
//  SampleData.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftData
import SwiftUI

/// Shared in-memory storage for previews, loaded from the SampleData asset.
///
/// The preview system creates the context once and reuses it across previews.
struct SampleData: PreviewModifier {
    static func makeSharedContext() throws -> Storage {
        try Storage(isStoredInMemoryOnly: true, assetName: "SampleData")
    }

    func body(content: Content, context: Storage) -> some View {
        content
            .environment(context)
            .modelContainer(context.container)
    }

    /// Unsaved subjects for previews that only need a long list.
    static func subjects(count: Int) -> [Subject] {
        var array = [Subject]()
        for i in 0..<count {
            array.append(Subject(title: "Subject " + String(format: "%02d", i)))
        }
        return array
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleData())
}
