//
//  EditorDelete.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI
import SwiftData

/// Delete button for an editor.
struct EditorDelete: ToolbarContent {
    @Environment(Navigation.self) private var navigation
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var confirmDelete: Bool = false
    let item: any PersistentModel
    let action: (() -> Void)?
    
    init(item: any PersistentModel, action: (() -> Void)? = nil) {
        self.item = item
        self.action = action
    }

    var body: some ToolbarContent {
        ToolbarItem(placement: .destructiveAction) {
            Button("Delete", role: .destructive) {
                withAnimation {
                    confirmDelete.toggle()
                }
            }
            .foregroundColor(.red)
            .confirmationDialog("Delete \(String(describing: item.self))?", isPresented: $confirmDelete) {
                Button("Delete", role: .destructive) {
                    withAnimation {
                        navigation.resetNavigationPath(for: item)
                        modelContext.delete(item)
                        if let action {
                            action()
                        }
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var navigation = Navigation()
    @Previewable @State var previewer = Previewer()
    NavigationStack {
        Form {
            Text("ABC")
        }
        .toolbar {
            EditorDelete(item: previewer.era!, action: {
                print("hello")
            })
        }
    }
    .frame(width: 400, height: 200)
    .environment(navigation)
    .modelContainer(previewer.storage.container)
}
