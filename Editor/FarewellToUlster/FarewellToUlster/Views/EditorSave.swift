//
//  EditorSave.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI

/// Save button for an editor.
struct EditorSave: ToolbarContent {
    @Environment(\.dismiss) private var dismiss
    let needsSave: Bool
    let save: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .destructiveAction) {
            Button("Save", role: .destructive) {
                withAnimation {
                    save()
                }
            }
            .disabled(!needsSave)
            .opacity(needsSave ? 1 : 0.75)
        }
    }
}

#Preview("Needs save") {
    NavigationStack {
        Form {
            Text("ABC")
        }
        .toolbar {
            EditorSave(needsSave: true) {
                print("Saving edited values")
            }
        }
    }
}

#Preview("Doesn't need save") {
    NavigationStack {
        Form {
            Text("ABC")
        }
        .toolbar {
            EditorSave(needsSave: false) {
                print("Saving edited values")
            }
        }
    }
}
