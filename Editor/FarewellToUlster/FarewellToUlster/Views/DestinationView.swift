//
//  DestinationView.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI
import SwiftData

/// Used to specify the navigation path.
enum Path: Hashable {
    case poem(Poem)
    case era(Era)
    case event(Event)
    case subject(Subject)
}

/// Used to specify the navigation destination.
struct DestinationView: View {
    let path: Path
    
    var body: some View {
        switch path {
        case .poem(let poem):
            PoemEditor(poem: poem)
        case .era(let era):
            EraEditor(era: era)
        case .event(let event):
            EventEditor(event: event)
        case .subject(let subject):
            SubjectEditor(subject: subject)
        }
    }
}

#if DEBUG
#Preview(traits: .sampleData) {
    @Previewable @State var navigation = Navigation()
    @Previewable @Environment(Storage.self) var storage
    DestinationView(path: .poem(storage.poems.first!))
        .environment(navigation)
}
#endif
