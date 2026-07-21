//
//  EditorCancel.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI

/// Cancel button for an editor.
struct EditorCancel: ToolbarContent {
    @Environment(\.dismiss) private var dismiss
    let needsSave: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel", role: .cancel) {
                withAnimation {
                    dismiss()
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
            EditorCancel(needsSave: true)
        }
    }
}

#Preview("Doesn't need save") {
    NavigationStack {
        Form {
            Text("ABC")
        }
        .toolbar {
            EditorCancel(needsSave: false)
        }
    }
}

