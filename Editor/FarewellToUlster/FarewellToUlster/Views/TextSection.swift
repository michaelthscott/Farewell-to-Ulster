//
//  TextSection.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI

enum TextSectionAutocapitalization {
    case never
    case sentences
}

struct TextSection: View {
    let title: String
    let autocapitalization: TextSectionAutocapitalization
    @Binding var text: String
    @State var sheetIsPresented: Bool = false

    var body: some View {
        Section {
            ZStack(alignment: .topLeading) {
                SelectableText(text)
                // Workaround to get SelectableText to dynamically resize to fit the text.
                Text(text)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 4)
                    .padding(.top, 8)
                    .opacity(.zero)
            }
            .font(.body)

        } header: {
            HStack {
                Text(title)
                Spacer()
                Button(action: {
                    sheetIsPresented.toggle()
                }, label: {
                    Image(systemName: "chevron.down")
                })
                .sheet(isPresented: $sheetIsPresented) {
                    TextSheet(title: title, autocapitalization: autocapitalization, text: $text)
                        .textCase(.none)
                }
            }
        }
    }
}

#Preview("Muiltiple lines") {
    @Previewable @State var text = "this is a line\nand another line\nand a third line\nand the last line"
    Form {
        TextSection(title: "Text", autocapitalization: .sentences, text: $text)
    }
}

#Preview("Long line") {
    @Previewable @State var text = "this is a very long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long piece of text"
    Form {
        TextSection(title: "Text", autocapitalization: .sentences, text: $text)
    }
}
