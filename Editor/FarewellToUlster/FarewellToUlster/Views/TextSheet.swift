//
//  TextSheet.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI

/// A sheet that contains a text editor.
struct TextSheet: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    let autocapitalization: TextSectionAutocapitalization
    @Binding var text: String
    @State private var originalText: String = ""

    var body: some View {
        NavigationStack {
            Form {
                ZStack(alignment: .topLeading) {
                    ControlledTextView(text: $text, font: .body, autocapitalization: autocapitalization)
                    // Workaround to get the TextEditor to dynamically resize to fit the text.
                    Text(text)
                        .padding(.leading, 4)
                        .padding(.top, 8)
                        .opacity(.zero)
                }
                .font(.body)
            }
            .navigationTitle(Text(title))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        text = originalText
                        dismiss()
                    }, label: {
                        Text("Cancel")
                            .textCase(.none)
                    })
                }
                ToolbarItem(placement: .destructiveAction) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.up")
                    })
                }
            })
        }
        .onAppear {
            originalText = text
        }
    }
}

#Preview {
    @Previewable @State var text = "this is a line\nand another line\nand a long long long long long long long long long long long long long line"
    TextSheet(title: "Text", autocapitalization: .sentences, text: $text)
}

