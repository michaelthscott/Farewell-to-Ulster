//
//  SubjectsOrderingSheet.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI
import SwiftData

struct SubjectsOrderingSheet: View {
    @Environment(\.editMode) var editMode
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Subject.sortIndex, order: .forward) private var subjectsSorted: [Subject]
    @State private var subjects: [Subject] = []
        
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    _subjects.wrappedValue = subjectsSorted
                    dismiss()
                }, label: {
                    Text("Cancel")
                })
                .padding()
                Spacer()
                Text("Subject Order")
                    .bold(true)
                    .padding()
                Spacer()
                Button(action: {
                    for index in subjects.indices {
                        subjects[index].sortIndex = index
                    }
                    dismiss()
                }, label: {
                    Text("Save")
                })
                .padding()
            }
            .background(.quinary)
            List($subjects, editActions: .move) { $subject in
                Text(subject.title)
            }
            .listStyle(.plain)
        }
        .onAppear() {
            editMode?.wrappedValue = .active
            subjects = subjectsSorted
        }
    }
}

#Preview {
    @Previewable @State var previewer = Previewer()
    SubjectsOrderingSheet()
        .modelContainer(previewer.storage.container)
}
