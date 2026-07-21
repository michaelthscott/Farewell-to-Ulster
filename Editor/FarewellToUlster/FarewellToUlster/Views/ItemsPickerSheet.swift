//
//  ItemsPickerSheet.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI

/// The sheet displayed to enable picking the item.
struct ItemsPickerSheet<Item: Identifiable & Equatable & Titled>: View {
    @Environment(\.dismiss) private var dismiss
    let items: [Item]
    @Binding var selection: [Item]
    @State private var originalSelection: [Item] = []
    @State private var searchText: String = ""

    var body: some View {
        // We need this for searchable() to work.
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    ForEach(filteredItems) { item in
                        Button(action: {
                            withAnimation {
                                if selection.contains(item) {
                                    selection.removeAll(where: { $0 == item })
                                } else {
                                    selection.append(item)
                                    selection.sort(by: { $0.title < $1.title })
                                }
                            }
                        }) {
                            HStack {
                                Text(item.title)
                                Spacer()
                                Image(systemName: "checkmark")
                                    .opacity(selection.contains(item) ? 1.0 : 0.0)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .searchable(text: $searchText)
            .navigationTitle(Text(verbatim: String(describing: Item.self)))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        selection = originalSelection
                        dismiss()
                    }, label: {
                        Text("Cancel")
                            .textCase(.none)
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.up")
                    })
                }
            }
            .onAppear() {
                originalSelection = selection
            }
        }
    }
    
    var filteredItems: [Item] {
        guard !searchText.isEmpty else { return items }
        return items.filter { $0.title.localizedStandardContains(searchText.lowercased()) }
    }
}

#Preview {
    @Previewable @State var previewer = Previewer()
    @Previewable @State var selection: [Subject] = []

    ItemsPickerSheet<Subject>(items: previewer.subjects(count: 100),
                              selection: $selection)
}
