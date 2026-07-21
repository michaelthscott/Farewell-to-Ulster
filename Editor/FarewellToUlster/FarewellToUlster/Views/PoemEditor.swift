//
//  PoemEditor.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

/// Display and edit a poem.
struct PoemEditor: View {
    @Environment(\.modelContext) private var modelContext
    let poem: Poem
    @Query(sort: \Era.period.start) private var eras: [Era]
    @Query(sort: \Event.period.start) private var events: [Event]
    @Query(sort: [SortDescriptor(\Subject.title, comparator: .localized)]) private var subjects: [Subject]
    @State private var editedTitle = ""
    @State private var editedText = ""
    @State private var editedScratchpad = ""
    @State private var selectedStatus: PoemStatus?
    @State private var selectedCategory: PoemCategory?
    @State private var selectedEra: Era?
    @State private var selectedEvents = [Event]()
    @State private var selectedSubjects = [Subject]()
    @State private var scratchpadSheetIsPresented = false

    var body: some View {
        Form {
            Section("Title") {
                TitleField(title: $editedTitle)
            }
            TextSection(title: "Text", autocapitalization: .never, text: $editedText)
            Section("Era") {
                HStack {
                    Spacer()
                    Picker(selection: $selectedEra, label: Text("Era")) {
                        if selectedEra == nil {
                            Text("no era selected")
                                .foregroundColor(.secondary)
                                .tag(Optional<Era>(nil))
                        }
                        ForEach(eras) { era in
                            Text(era.title).tag(Optional(era))
                        }
                    }
                    .labelsHidden()
                }
            }
            ItemsPicker<Event>(items: events, selection: $selectedEvents)
            ItemsPicker<Subject>(items: subjects, selection: $selectedSubjects)
            Section("Category") {
                Picker("Category", selection: $selectedCategory) {
                    if selectedCategory == nil {
                        Text("no category selected")
                            .foregroundColor(.secondary)
                            .tag(Optional<PoemCategory>(nil))
                    }
                    ForEach(PoemCategory.allCases) { category in
                        Text(category.rawValue).tag(Optional(category))
                    }
                }
            }
            Section("Status") {
                Picker("Status", selection: $selectedStatus) {
                    if selectedStatus == nil {
                        Text("no status selected")
                            .foregroundColor(.secondary)
                            .tag(Optional<PoemStatus>(nil))
                    }
                    ForEach(PoemStatus.allCases) { status in
                        Text(status.rawValue).tag(Optional(status))
                    }
                }
            }
            TextSection(title: "Scratchpad", autocapitalization: .sentences, text: $editedScratchpad)
        }
        .navigationTitle(Text("Edit Poem"))
        .navigationBarBackButtonHidden(needsSave)
        .toolbar {
            EditorCancel(needsSave: needsSave)
            EditorSave(needsSave: needsSave) {
                poem.title = editedTitle
                poem.text = editedText
                poem.scratchpad = editedScratchpad
                poem.status = selectedStatus
                poem.category = selectedCategory
                poem.era = selectedEra
                poem.events = selectedEvents
                poem.subjects = selectedSubjects
            }
            EditorDelete(item: poem)
        }
        .onAppear {
            editedTitle = poem.title
            editedText = poem.text
            editedScratchpad = poem.scratchpad
            selectedStatus = poem.status
            selectedCategory = poem.category
            selectedEra = poem.era
            selectedEvents = poem.sortedEvents
            selectedSubjects = poem.sortedSubjects
        }
    }
    
    var needsSave: Bool {
        editedTitle != poem.title ||
        editedText != poem.text ||
        editedScratchpad != poem.scratchpad ||
        selectedStatus != poem.status ||
        selectedCategory != poem.category ||
        selectedEra != poem.era ||
        selectedEvents.sorted() != poem.sortedEvents ||
        selectedSubjects.sorted() != poem.sortedSubjects
    }
}

#Preview {
    @Previewable @State var navigation = Navigation()
    @Previewable @State var previewer = Previewer()
    NavigationStack {
        PoemEditor(poem: previewer.poem!)
            .navigationDestination(for: Path.self) { path in
                DestinationView(path: path)
            }
            .modelContext(previewer.storage.container.mainContext)
            .environment(navigation)
    }
}
