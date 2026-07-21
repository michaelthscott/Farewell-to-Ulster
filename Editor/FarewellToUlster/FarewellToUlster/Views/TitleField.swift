//
//  TitleField.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI

private extension CharacterSet {
    static var whitespacesNewlinesAndPunctuation: CharacterSet {
        var characterSet: CharacterSet = .whitespacesAndNewlines
        characterSet.formUnion(.punctuationCharacters)
        return characterSet
    }
}

private extension String {
    var capitalizedFirstLetter: String {
        prefix(1).capitalized + dropFirst()
    }
}

/// A text field used to display and edit a title.
struct TitleField: View {
    @Binding var title: String
    let capitalizeFirstLetter: Bool
    
    init(title: Binding<String>, capitalizeFirstLetter: Bool = true) {
        self._title = title
        self.capitalizeFirstLetter = capitalizeFirstLetter
    }
        
    var body: some View {
        TextField("Title", text: $title)
            .keyboardType(.asciiCapable)
            .disableAutocorrection(true)
            .autocapitalization(capitalizeFirstLetter ? .sentences : .none)
            .onAppear() {
                title = title.trimmingCharacters(in: .whitespacesNewlinesAndPunctuation)
                if capitalizeFirstLetter {
                    title = title.capitalizedFirstLetter
                }
            }
            .onSubmit {
                title = title.trimmingCharacters(in: .whitespacesNewlinesAndPunctuation)
                if capitalizeFirstLetter {
                    title = title.capitalizedFirstLetter
                }
            }
    }
}

#Preview("Capitalised") {
    @Previewable @State var title: String = "this is a test"
    Form {
        TitleField(title: $title)
    }
}

#Preview("Uncapitalised") {
    @Previewable @State var title: String = "this is a test"
    Form {
        TitleField(title: $title, capitalizeFirstLetter: false)
    }
}

#Preview("Trailing whitespace") {
    @Previewable @State var title: String = "this is a test "
    Form {
        TitleField(title: $title, capitalizeFirstLetter: true)
    }
}

