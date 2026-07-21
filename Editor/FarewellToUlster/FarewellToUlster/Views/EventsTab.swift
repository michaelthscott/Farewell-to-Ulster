//
//  EventsTab.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI
import SwiftData

/// Display the events. If an era is selected then only the events within that era will be displayed.
struct EventsTab: View {
    @Environment(Navigation.self) private var navigation
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Event.period.start) private var events: [Event]
    @State private var addFailed: Bool = false
    @State private var addError: String = ""
    @State private var searchText = ""

    var body: some View {
        @Bindable var navigation = navigation
        NavigationStack(path: $navigation.eventsPath) {
            List {
                ForEach(selectedEvents) { event in
                    NavigationLink(value: Path.event(event)) {
                        Label {
                            Text(event.title)
                                .font(.headline)
                            Text(event.period.periodDescription)
                                .font(.subheadline)
                        } icon: {
                            Image(systemName: "checkmark")
                                .opacity(navigation.selectedEvent == event ? 1.0 : 0.0)
                                .onTapGesture {
                                    if navigation.selectedEvent == event {
                                        navigation.selectedEvent = nil
                                    } else {
                                        navigation.selectedEvent = event
                                        navigation.eventsPath.append(Path.event(event))
                                    }
                                }
                        }
                        .badge(event.poemsCount)
                    }
                }
            }
            .navigationDestination(for: Path.self) { path in
                DestinationView(path: path)
            }
            .navigationTitle("Events")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackgroundVisibility(.visible, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: addEvent) {
                        Label("Add event", systemImage: "plus")
                    }
                    .alert("Add failed: \(addError)", isPresented: $addFailed) {
                        Button("Ok", role: .cancel) {
                            addFailed = false
                            addError = ""
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText)
    }
    
    var selectedEvents: [Event] {
        guard !searchText.isEmpty else { return filteredEvents }
        return filteredEvents.filter { era in
            era.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var filteredEvents: [Event] {
        guard let selectedEra = navigation.selectedEra else { return events }
        return events.filter { event in
            selectedEra.period.contains(event.period.start)
        }
    }
    
    private func addEvent() {
        withAnimation {
            let newEvent = Event()
            do {
                try modelContext.insertOrdered(newEvent)
                navigation.eventsPath.append(Path.event(newEvent))
            } catch let error as FileOrderedError {
                // If the model is new and in an unsaved state, the context simply discards it.
                modelContext.delete(newEvent)
                addFailed = true
                addError = error.description
            } catch {
                modelContext.delete(newEvent)
                addFailed = true
                addError = "Unknown"
            }
        }
    }
}

#Preview {
    @Previewable @State var navigation = Navigation()
    @Previewable @State var previewer = Previewer()
    EventsTab()
        .environment(navigation)
        .modelContainer(previewer.storage.container)
}
