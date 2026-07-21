//
//  SubjectsTab.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI
import SwiftData

/// Displays a list of subjects, which can be filtered by category.
struct SubjectsTab: View {
    @Environment(Navigation.self) private var navigation
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: [SortDescriptor(\Subject.title, comparator: .localized)]) private var subjects: [Subject]
    @State private var selectedCategory: SubjectCategory?
    @State private var showOrdering: Bool = false
    @State private var addFailed: Bool = false
    @State private var addError: String = ""
    @State private var searchText = ""

    var body: some View {
        @Bindable var navigation = navigation
        NavigationStack(path: $navigation.subjectsPath) {
            VStack {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(SubjectCategory.allCases) { category in
                        Text(category.rawValue).tag(Optional(category))
                    }
                }
                .labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
                .onTapGesture(count: 2) {
                    selectedCategory = nil
                }
                List {
                    ForEach(selectedSubjects) { subject in
                        NavigationLink(value: Path.subject(subject)) {
                            Label {
                                Text(subject.title)
                                    .badge(subject.poemsCount)
                            } icon: {
                                Image(systemName: "checkmark")
                                    .opacity(navigation.selectedSubject == subject ? 1.0 : 0.0)
                                    .onTapGesture {
                                        if navigation.selectedSubject == subject {
                                            navigation.selectedSubject = nil
                                        } else {
                                            navigation.selectedSubject = subject
                                            navigation.subjectsPath.append(Path.subject(subject))
                                        }
                                    }
                            }
                        }
                    }
                }
                .navigationDestination(for: Path.self) { path in
                    DestinationView(path: path)
                }
                .navigationTitle("Subjects")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackgroundVisibility(.visible, for: .tabBar)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: addSubject) {
                            Label("Add subject", systemImage: "plus")
                        }
                        .alert("Add failed: \(addError)", isPresented: $addFailed) {
                            Button("Ok", role: .cancel) {
                                addFailed = false
                                addError = ""
                            }
                        }
                    }
                    ToolbarItem(placement: .secondaryAction) {
                        Button {
                            showOrdering.toggle()
                        } label: {
                            Label("Order subjects", systemImage: "arrow.up.arrow.down")
                        }
                        .sheet(isPresented: $showOrdering) {
                            SubjectsOrderingSheet()
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText)
    }
    
    var selectedSubjects: [Subject] {
        guard !searchText.isEmpty else { return filteredSubjects }
        return filteredSubjects.filter { subject in
            subject.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var filteredSubjects: [Subject] {
        guard let category = selectedCategory else { return subjects }
        return subjects.filter({ $0.category == category })
    }

    private func addSubject() {
        withAnimation {
            let index = subjects.count
            let newSubject = Subject()
            do {
                try modelContext.insertOrdered(newSubject)
                newSubject.sortIndex = index
                navigation.subjectsPath.append(Path.subject(newSubject))
                
            } catch let error as FileOrderedError {
                // If the model is new and in an unsaved state, the context simply discards it.
                modelContext.delete(newSubject)
                addFailed = true
                addError = error.description
            } catch {
                modelContext.delete(newSubject)
                addFailed = true
                addError = "Unknown"
            }
        }
    }
}

#Preview {
    @Previewable @State var navigation = Navigation()
    @Previewable @State var previewer = Previewer()
    SubjectsTab()
        .environment(navigation)
        .modelContainer(previewer.storage.container)
}
