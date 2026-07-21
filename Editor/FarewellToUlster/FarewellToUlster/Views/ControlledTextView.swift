//
//  ControlledTextView.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation
import SwiftUI
import UIKit

struct ControlledTextView: UIViewRepresentable {
    @Binding var text: String
    var isScrollEnabled: Bool = true
    var font: SwiftUI.Font
    var autocapitalization: TextSectionAutocapitalization

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = isScrollEnabled
        view.delegate = context.coordinator
        view.textAlignment = .left
        view.keyboardType = .asciiCapable
        if let uiFont = convertToUIFont(font) {
            view.font = uiFont
        }
        switch autocapitalization {
        case .sentences:
            view.autocapitalizationType = .sentences
        case .never:
            view.autocapitalizationType = .none
        }
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: ControlledTextView

        init(_ parent: ControlledTextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            // Prevent auto-scroll by restoring offset
            let currentOffset = textView.contentOffset
            textView.setContentOffset(currentOffset, animated: false)
        }
    }
    
    func convertToUIFont(_ swiftUIFont: SwiftUI.Font) -> UIFont? {
        switch swiftUIFont {
        case .largeTitle:
            return UIFont.preferredFont(forTextStyle: .largeTitle)
        case .title:
            return UIFont.preferredFont(forTextStyle: .title1)
        case .title2:
            return UIFont.preferredFont(forTextStyle: .title2)
        case .title3:
            return UIFont.preferredFont(forTextStyle: .title3)
        case .headline:
            return UIFont.preferredFont(forTextStyle: .headline)
        case .subheadline:
            return UIFont.preferredFont(forTextStyle: .subheadline)
        case .body:
            return UIFont.preferredFont(forTextStyle: .body)
        case .callout:
            return UIFont.preferredFont(forTextStyle: .callout)
        case .footnote:
            return UIFont.preferredFont(forTextStyle: .footnote)
        case .caption:
            return UIFont.preferredFont(forTextStyle: .caption1)
        case .caption2:
            return UIFont.preferredFont(forTextStyle: .caption2)
        default:
            // Fallback: default system font
            return UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
    }
}

#Preview {
    @Previewable @State var text = "this is a line\nand another line\nand a long long long long long long long long long long long long long line"
    ControlledTextView(text: $text, font: .body, autocapitalization: .sentences)
  
}
