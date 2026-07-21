//
//  SelectableText.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI

/// Text that can be selected.
struct SelectableText: UIViewRepresentable {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isSelectable = true
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainerInset.bottom = 0
        textView.textAlignment = .justified
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

#Preview("Multiple lines") {
    SelectableText("This is a \nmultiple\nline")
}

#Preview("Long line") {
    SelectableText("This is a very long long long long long long long long long long long long long long long long long long long long long long long long long long long long line")
}
