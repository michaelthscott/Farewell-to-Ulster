//
//  SubjectEditor.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

/// Display and edit a subject.
struct SubjectEditor: View {
    @Environment(Navigation.self) private var navigation
    @Environment(\.modelContext) private var modelContext
    let subject: Subject
    @State private var editedTitle = ""
    @State private var selectedCategory: SubjectCategory?
    @State private var confirmDelete: Bool = false
    @State private var showExporter = false
    @State private var contentType: UTType = .plainText
    @State private var defaultFileName: String = "Untitled"

    var body: some View {
        Form {
            Section("Title") {
                TitleField(title: $editedTitle, capitalizeFirstLetter: false)
            }
            Section("Category") {
                HStack {
                    Spacer()
                    Picker("Category", selection: $selectedCategory) {
                        if selectedCategory == nil {
                            Text("no category selected")
                                .foregroundColor(.secondary)
                                .tag(Optional<SubjectCategory>(nil))
                        }
                        ForEach(SubjectCategory.allCases) { category in
                            Text(category.rawValue).tag(Optional(category))
                        }
                    }
                    .labelsHidden()
                }
            }
        }
        .navigationTitle(Text("Edit Subject"))
        .navigationBarBackButtonHidden(needsSave)
        .toolbar {
            EditorCancel(needsSave: needsSave)
            EditorSave(needsSave: needsSave) {
                subject.title = editedTitle
                subject.category = selectedCategory
            }
            EditorDelete(item: subject) {
                do {
                    try modelContext.reindexSubjects()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .onAppear {
            navigation.selectedSubject = subject
            editedTitle = subject.title
            selectedCategory = subject.category
        }
    }
    
    var needsSave: Bool {
        subject.title != editedTitle || subject.category != selectedCategory
    }
}

#Preview {
    @Previewable @State var navigation = Navigation()
    @Previewable @State var previewer = Previewer()
    NavigationStack {
        SubjectEditor(subject: previewer.subject!)
            .navigationDestination(for: Path.self) { path in
                DestinationView(path: path)
            }
            .environment(navigation)
    }
}
