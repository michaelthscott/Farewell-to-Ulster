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

#Preview {
    @Previewable @State var navigation = Navigation()
    @Previewable @State var previewer = Previewer()
    NavigationStack {
        EventEditor(event: previewer.event!)
            .navigationDestination(for: Path.self) { path in
                DestinationView(path: path)
            }
            .environment(navigation)
            .modelContainer(previewer.storage.container)
    }
}
