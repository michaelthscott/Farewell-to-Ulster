//
//  GitHubSettingsView.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 22/07/2026.
//

import SwiftUI

/// Save or replace the GitHub token. Reached from the Book tab menu, and offered
/// directly when a commit fails because the token is missing or expired.
struct GitHubSettingsView: View {
    @State private var tokenInput = ""
    @State private var savedMessage: String?

    var body: some View {
        Form {
            Section("GitHub Token") {
                SecureField("Paste token here", text: $tokenInput)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                Button("Save Token") {
                    save()
                }
                .disabled(tokenInput.isEmpty)

                if let savedMessage {
                    Text(savedMessage)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func save() {
        do {
            try iCloudKeychain.save(token: tokenInput)
            savedMessage = "Token saved"
            tokenInput = ""  // clear the field, don't leave it sitting in view state
        } catch {
            savedMessage = "Failed to save: \(error.localizedDescription)"
        }
    }
}

#Preview {
    GitHubSettingsView()
}
