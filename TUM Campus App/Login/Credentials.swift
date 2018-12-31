//
//  Credentials.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 12/31/18.
//  Copyright © 2018 TUM. All rights reserved.
//

import Foundation


struct Credentials {
    
    enum KeychainError: Error {
        case noToken
        case unexpectedTokenData
        case unhandledError(status: OSStatus)
    }
    
    static let server = "https://campus.tum.de/tumonline"
    
    private(set) var tumID: String
    private(set) var token: String
    
    init?() {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: Credentials.server,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else { return nil }
        
        guard let existingItem = item as? [String : Any],
            let tumID = existingItem[kSecAttrAccount as String] as? String,
            let tokenData = existingItem[kSecValueData as String] as? Data,
            let token = String(data: tokenData, encoding: .utf8)
            else { return nil }
        
        self.token = token
        self.tumID = tumID
    }
    
    init?(tumID: String, token: String) {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: tumID,
                                    kSecAttrServer as String: Credentials.server,
                                    kSecValueData as String: token]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { return nil }
        
        self.tumID = tumID
        self.token = token
    }
    
    func delete() {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: tumID,
                                    kSecAttrServer as String: Credentials.server]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { return }
    }
    
}
