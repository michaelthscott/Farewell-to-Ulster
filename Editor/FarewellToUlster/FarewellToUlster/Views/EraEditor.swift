//
//  EraEditor.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

/// Display and edit an era.
struct EraEditor: View {
    @Environment(Navigation.self) private var navigation
    let era: Era
    @State private var editedTitle = ""
    @State private var editedText = ""
    @State private var selectedPeriod: DateInterval = .init()

    var body: some View {
        Form {
            Section("Title") {
                TitleField(title: $editedTitle)
            }
            PeriodPicker(period: $selectedPeriod)
            TextSection(title: "Text", autocapitalization: .never, text: $editedText)
        }
        .navigationTitle(Text("Edit Era"))
        .navigationBarBackButtonHidden(needsSave)
        .toolbar {
            EditorCancel(needsSave: needsSave)
            EditorSave(needsSave: needsSave) {
                era.title = editedTitle
                era.period = selectedPeriod
                era.text = editedText
            }
            EditorDelete(item: era)
        }
        .onAppear {
            navigation.selectedEra = era
            editedTitle = era.title
            selectedPeriod = era.period
            editedText  = era.text
        }
    }
    
    var needsSave: Bool {
        era.title != editedTitle || era.period != selectedPeriod || era.text != editedText
    }
    
}

#if DEBUG
#Preview(traits: .sampleData) {
    @Previewable @State var navigation = Navigation()
    @Previewable @Environment(Storage.self) var storage
    NavigationStack {
        EraEditor(era: storage.eras.first!)
            .navigationDestination(for: Path.self) { path in
                DestinationView(path: path)
            }
            .environment(navigation)
    }
}
#endif
