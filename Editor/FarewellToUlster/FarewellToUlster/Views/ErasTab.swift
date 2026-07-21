//
//  ErasTab.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI
import SwiftData

/// Display the eras. One era can be selected.
struct ErasTab: View {
    @Environment(Navigation.self) private var navigation
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Era.period.start) private var eras: [Era]
    @State private var addFailed: Bool = false
    @State private var addError: String = ""
    @State private var searchText = ""

    var body: some View {
        @Bindable var navigation = navigation
        NavigationStack(path: $navigation.erasPath) {
            List {
                ForEach(selectedEras) { era in
                    NavigationLink(value: Path.era(era)) {
                        Label {
                            Text(era.title)
                                .font(.headline)
                            Text(era.period.periodDescription)
                                .font(.subheadline)
                        } icon: {
                            Image(systemName: "checkmark")
                                .opacity(navigation.selectedEra == era ? 1.0 : 0.0)
                                .onTapGesture {
                                    if navigation.selectedEra == era {
                                        navigation.selectedEra = nil
                                    } else {
                                        navigation.selectedEra = era
                                        navigation.erasPath.append(Path.era(era))
                                    }
                                }
                        }
                        .badge(era.poemsCount)
                    }
                }
            }
            .navigationDestination(for: Path.self) { path in
                DestinationView(path: path)
            }
            .navigationTitle("Eras")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackgroundVisibility(.visible, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: addEra) {
                        Label("Add era", systemImage: "plus")
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
    
    var selectedEras: [Era] {
        guard !searchText.isEmpty else { return eras }
        return eras.filter { era in
            era.title.localizedCaseInsensitiveContains(searchText)
        }
    }

    private func addEra() {
        withAnimation {
            let newEra = Era()
            do {
                try modelContext.insertOrdered(newEra)
                navigation.erasPath.append(Path.era(newEra))
            } catch let error as FileOrderedError {
                // If the model is new and in an unsaved state, the context simply discards it.
                modelContext.delete(newEra)
                addFailed = true
                addError = error.description
            } catch {
                modelContext.delete(newEra)
                addFailed = true
                addError = "Unknown"
            }
        }
    }
}

#Preview {
    @Previewable @State var navigation = Navigation()
    @Previewable @State var previewer = Previewer()
    ErasTab()
        .environment(navigation)
        .modelContainer(previewer.storage.container)
}
