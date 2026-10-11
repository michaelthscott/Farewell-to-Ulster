//
//  EventEditor.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

/// Display and edit an event.
struct EventEditor: View {
    @Environment(Navigation.self) private var navigation
    let event: Event
    @State private var editedTitle = ""
    @State private var selectedPeriod: DateInterval = .init()

    var body: some View {
        Form {
            Section("Title") {
                TitleField(title: $editedTitle)
            }
            PeriodPicker(period: $selectedPeriod)
        }
        .navigationTitle(Text("Edit Event"))
        .navigationBarBackButtonHidden(needsSave)
        .toolbar {
            EditorCancel(needsSave: needsSave)
            EditorSave(needsSave: needsSave) {
                event.title = editedTitle
                event.period = selectedPeriod
            }
            EditorDelete(item: event)
        }
        .onAppear {
            navigation.selectedEvent = event
            editedTitle = event.title
            selectedPeriod = event.period
        }
    }
    
    var needsSave: Bool {
        event.title != editedTitle || event.period != selectedPeriod
    }
}

#if DEBUG
#Preview(traits: .sampleData) {
    @Previewable @State var navigation = Navigation()
    @Previewable @Environment(Storage.self) var storage
    NavigationStack {
        EventEditor(event: storage.events.first!)
            .navigationDestination(for: Path.self) { path in
                DestinationView(path: path)
            }
            .environment(navigation)
    }
}
#endif
