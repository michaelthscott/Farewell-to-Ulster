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

#Preview {
    @Previewable @State var navigation = Navigation()
    @Previewable @State var previewer = Previewer()
    DestinationView(path: .poem(previewer.poem!))
        .environment(navigation)
        .modelContainer(previewer.storage.container)
}
