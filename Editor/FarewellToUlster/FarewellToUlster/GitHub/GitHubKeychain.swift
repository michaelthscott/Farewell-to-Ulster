//
//  GitHubKeychain.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 22/07/2026.
//

import Foundation

enum GitHubKeychain {
    static let service = "org.michaelthscott.FarewellToUlster"
    static let account = "github-pat"

    static func save(token: String) throws {
        let tokenData = Data(token.utf8)

        // Remove any existing item first
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecAttrSynchronizable as String: kSecAttrSynchronizableAny
        ]
        SecItemDelete(deleteQuery as CFDictionary)

        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: tokenData,
            kSecAttrSynchronizable as String: true,               // <- syncs via iCloud Keychain
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock        ]

        let status = SecItemAdd(addQuery as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw NSError(domain: "GitHubKeychain", code: Int(status),
                           userInfo: [NSLocalizedDescriptionKey: "Failed to save token (\(status))"])
        }
    }

    static func load() throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecAttrSynchronizable as String: true,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecItemNotFound { return nil }
        guard status == errSecSuccess, let data = result as? Data else {
            throw NSError(domain: "GitHubKeychain", code: Int(status),
                           userInfo: [NSLocalizedDescriptionKey: "Failed to load token (\(status))"])
        }
        return String(data: data, encoding: .utf8)
    }

    static func delete() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecAttrSynchronizable as String: true
        ]
        SecItemDelete(query as CFDictionary)
    }
}
