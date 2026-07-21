//
//  ItemsPicker.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI

/// A generic picker for titled items.
struct ItemsPicker<Item: Identifiable & Equatable & Titled>: View {
    let items: [Item]
    @Binding var selection: [Item]
    @State var sheetIsPresented: Bool = false
    
    var body: some View {
        Section {
            ForEach(selection) { item in
                Text(item.title)
            }
        } header: {
            HStack {
                Text("Selected \(String(describing: Item.self))s")
                Spacer()
                Button(action: {
                    sheetIsPresented.toggle()
                }, label: {
                    Image(systemName: "chevron.down")
                })
                .sheet(isPresented: $sheetIsPresented) {
                    ItemsPickerSheet(items: items, selection: $selection)
                        .textCase(.none)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var previewer = Previewer()
    @Previewable @State var selection: [Subject] = []

    Form {
        ItemsPicker<Subject>(items: previewer.subjects(count: 100),
                             selection: $selection)
    }
}
