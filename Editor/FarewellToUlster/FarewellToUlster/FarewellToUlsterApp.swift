//
//  FarewellToUlsterApp.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI
import SwiftData

@main
struct FarewellToUlsterApp: App {
    @State private var storage: Storage? = nil
    @State private var navigation = Navigation()
    @State private var message: String? = nil
    
    var body: some Scene {
        WindowGroup {
            if let storage {
                ContentView()
                    .modelContainer(storage.container)
                    .environment(navigation)
            } else if let message {
                Text(message)
            } else {
                ProgressView("Loading...")
                    .onAppear(perform: createStorage)
            }
        }
    }
    
    private func createStorage() {
        do {
            storage = try Storage()
        } catch {
            message = "Failed to create storage: \(error)"
        }
    }
}
