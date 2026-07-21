//
//  ContentView.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI
import SwiftData

/// Display and select eras, events and subjects, to filter the poems.
struct ContentView: View {
    @Environment(Navigation.self) private var navigation
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        @Bindable var navigation = navigation
        TabView(selection: $navigation.selectedTab) {
            Tab("Book", systemImage: "book", value: TabValue.book) {
                BookTab()
            }
            Tab("Eras", systemImage: "calendar", value: TabValue.eras) {
                ErasTab()
            }
            .badge(
                navigation.selectedEra != nil ? Text("✓") : nil
            )
            Tab("Events", systemImage: "clock", value: TabValue.events) {
                EventsTab()
            }
            .badge(
                navigation.selectedEvent != nil ? Text("✓") : nil
            )
            Tab("Subjects", systemImage: "list.bullet", value: TabValue.subjects) {
                SubjectsTab()
            }
            .badge(
                navigation.selectedSubject != nil ? Text("✓") : nil
            )
            Tab("Poems", systemImage: "book.pages", value: TabValue.poems) {
                PoemsTab()
            }
        }
    }
}

#Preview {
    @Previewable @State var navigation = Navigation()
    @Previewable @State var previewer = Previewer()
    ContentView()
        .environment(navigation)
        .modelContainer(previewer.storage.container)
}
