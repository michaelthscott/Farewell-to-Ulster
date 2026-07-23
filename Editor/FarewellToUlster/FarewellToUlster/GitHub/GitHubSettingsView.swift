//
//  GitHubSettingsView.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 22/07/2026.
//

import SwiftUI

// TODO: This needs to be made available to update the token when it expires.

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
            try GitHubKeychain.save(token: tokenInput)
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
