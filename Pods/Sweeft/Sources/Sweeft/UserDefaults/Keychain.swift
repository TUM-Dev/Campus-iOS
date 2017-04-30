//
//  Keychain.swift
//  Pods
//
//  Created by Mathias Quintero on 4/29/17.
//
//

import Security

struct Keychain: StorageItem {
    
    static let standard = Keychain()
    
    func delete(at key: String) {
        
        let query: [String : Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrService as String : key,
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
    func set(_ value: Any?, forKey defaultName: String) {
        
        guard let value = value else {
            return delete(at: defaultName)
        }
        
        guard let data = try? PropertyListSerialization.data(fromPropertyList: value, format: .binary, options: 0) else {
            return
        }
        
        let query: [String : Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrService as String : defaultName,
        ]
        
        let dataQuery: [String : Any] = [
            kSecAttrService as String : defaultName,
            kSecValueData as String : data,
        ]
        
        let status = SecItemUpdate(query as CFDictionary, dataQuery as CFDictionary)
        
        if status == errSecItemNotFound {
            
            let createQuery: [String : Any] = [
                kSecClass as String : kSecClassGenericPassword,
                kSecAttrService as String : defaultName,
                kSecValueData as String : data,
                kSecAttrAccessible as String : kSecAttrAccessibleWhenUnlocked,
            ]

            SecItemAdd(createQuery as CFDictionary, nil)
        }
        
    }
    
    func object(forKey defaultName: String) -> Any? {
        
        var result: CFTypeRef?
        
        let query: [String : Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrService as String : defaultName,
            kSecMatchLimit as String : kSecMatchLimitOne,
            kSecReturnData as String : kCFBooleanTrue,
        ]

        
        let status = withUnsafeMutablePointer(to: &result) { pointer in
            
            return SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(pointer))
        }
        
        guard status == errSecSuccess, let data = result as? Data else {
            return nil
        }
        
        return try? PropertyListSerialization.propertyList(from: data, format: nil)
    }
    
}

