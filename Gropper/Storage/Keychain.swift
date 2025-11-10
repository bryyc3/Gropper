//
//  Keychain.swift
//  Gropper
//
//  Created by Bryce King on 6/24/25.
//

import Foundation
import Security

func storeItem(item: String, forKey key: String) throws {
    if let data = item.data(using: .utf8) {
           let query: [String: Any] = [
               kSecClass as String: kSecClassGenericPassword,
               kSecAttrAccount as String: key,
               kSecValueData as String: data,
               kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
           ]

           let status = SecItemAdd(query as CFDictionary, nil)

           guard status != errSecDuplicateItem else {
              throw KeychainError.duplicateEntry
           }

           guard status == errSecSuccess else {
              throw KeychainError.unknown(status)
           }
    }
}

func getItem(forKey key: String) -> String? {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecReturnData as String: true,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]
    
    var dataTypeRef: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

    if status == errSecSuccess, let data = dataTypeRef as? Data {
         return String(data: data, encoding: .utf8)
    }
    else {
        return nil
    }
}

func updateItem(item: String, forKey key: String) throws {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key
    ]
    
    let attributes: [String: Any] = [kSecValueData as String: item.data(using: .utf8)!]
    let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
    
    guard status != errSecItemNotFound else {
        print("item not found")
        throw KeychainError.itemNotFound
    }
    guard status == errSecSuccess else {
        print(status)
        throw KeychainError.unknown(status)
    }
}

func deleteToken(forKey key: String) throws {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key
    ]
    
    let status = SecItemDelete(query as CFDictionary)
    
    guard status == errSecSuccess else {
        throw KeychainError.unknown(status)
    }
    print("Deleted item")
}

enum KeychainError: Error {
        case duplicateEntry
        case itemNotFound
        case unknown(OSStatus)
}
