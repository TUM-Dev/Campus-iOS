//
//  KeychainService.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 28.01.23.
//

import Foundation
import KeychainAccess

typealias RSAKeyPair = (privateKey: String, publicKey: String)

enum RSAKeyPairError: Error {
    case failedGeneratingPrivateKey
    case failedObtainingKeyPairFromKeyChain
    case failedObtainingPublicKeyFromPrivateKey
    case failedObtainingStringRepresentationOfPrivateKey
    case failedObtainingStringRepresentationOfPublicKey
    case failedToExportPublicKey
}

class KeychainService {
    private let privateKeyApplicationTag = "de.tum.tca.keys.push_rsa_key"
    private let keychainAccessGroupName = "2J3C6P6X3N.de.tum.tca.notificationextension"
    private let keyType = kSecAttrKeyTypeRSA as String
    private let keySize = 2048
    private let keychain = Keychain(service: "de.tum.campusapp")
        .synchronizable(true)
        .accessibility(.afterFirstUnlock)
    
    private var credentials: Credentials? {
        guard let data = keychain[data: "credentials"] else { return nil }
        return try? PropertyListDecoder().decode(Credentials.self, from: data)
    }
    
    var campusToken: String? {
        switch credentials {
        case .none, .noTumID:
            return nil
        case .tumID(_, let token):
            return token
        case .tumIDAndKey(_, let token, _):
            return token
        }
    }
    
    /**
     Checks if the there are already public and private keys stored in the keychain. If yes, it just returns them, otherwise it generates new ones.
     
     - Returns: A tuple containing the RSA public and private key
     */
    func getPublicPrivateKeys() throws -> RSAKeyPair {
        if checkIfPrivateKeyAlreadyExists() {
            return try obtainPublicPrivateKeyFromKeyChain()
        }
        
        try generatePrivateKey()
        
        return try obtainPublicPrivateKeyFromKeyChain()
    }
    
    /**
     Uses `CryptoExportImportManager` to export the public key in a format (PEM) that can be read by the backend
     */
    private func exportPublicKeyAsValidPEM(_ publicKey: Data) -> String {
        let exportManager = CryptoExportImportManager()
        
        return exportManager.exportRSAPublicKeyToPEM(publicKey, keyType: keyType, keySize: keySize)
    }
    
    /**
     Generates a private inside the Keychain can then be queried afterwards
     */
    private func generatePrivateKey() throws {
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: keyType,
            kSecAttrKeySizeInBits as String: keySize,
                kSecPrivateKeyAttrs as String: [
                    kSecAttrIsPermanent as String: true,
                    kSecAttrApplicationTag as String: privateKeyApplicationTag
                ],
                kSecAttrAccessGroup as String: keychainAccessGroupName
        ]
        
        var error: Unmanaged<CFError>?
        guard SecKeyCreateRandomKey(attributes as CFDictionary, &error) != nil else {
            throw RSAKeyPairError.failedGeneratingPrivateKey
        }
    }
    
    
    private func checkIfPrivateKeyAlreadyExists() -> Bool {
        do {
            let _ = try obtainPrivateKeyFromKeyChain()
        } catch {
            return false
        }
        
        return true
    }
    
    /**
     Tries to query for the private key using the `privateKeyKeychainQuery`
     */
    func obtainPrivateKeyFromKeyChain() throws -> SecKey {
        var item: CFTypeRef?
        let status = SecItemCopyMatching(privateKeyKeychainQuery as CFDictionary, &item)
        
        guard status == errSecSuccess && item != nil else {
            throw RSAKeyPairError.failedObtainingKeyPairFromKeyChain
        }
        
        return item as! SecKey
    }
    
    func obtainPrivateKeyFromKeyChain() throws -> String {
        let privateKey: SecKey = try obtainPrivateKeyFromKeyChain()
        
        var error: Unmanaged<CFError>?
        guard let privateERData = SecKeyCopyExternalRepresentation(privateKey, &error) else {
            throw RSAKeyPairError.failedObtainingStringRepresentationOfPrivateKey
        }
        
        let privateData: Data = privateERData as Data
        
        return privateData.base64EncodedString()
    }
    
    /**
     Obtains the private key from the keychain, creates a public key from the private key and finally returns an external representation for the keys.
     */
    private func obtainPublicPrivateKeyFromKeyChain() throws -> RSAKeyPair {
        let privateKey: SecKey = try obtainPrivateKeyFromKeyChain()
                
        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            throw RSAKeyPairError.failedObtainingPublicKeyFromPrivateKey
        }
        
        var error: Unmanaged<CFError>?
        guard let privateERData = SecKeyCopyExternalRepresentation(privateKey, &error) else {
            throw RSAKeyPairError.failedObtainingStringRepresentationOfPrivateKey
        }
        
        let privateData: Data = privateERData as Data
        
        guard let publicERData = SecKeyCopyExternalRepresentation(publicKey, &error) else {
            throw RSAKeyPairError.failedObtainingStringRepresentationOfPublicKey
        }
        
        let publicData: Data = publicERData as Data
        
        return (privateData.base64EncodedString(), exportPublicKeyAsValidPEM(publicData))
    }
    
    private var privateKeyKeychainQuery: [String: Any] {
        return [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrKeyType as String: keyType,
            kSecAttrKeySizeInBits as String: keySize,
            kSecAttrApplicationTag as String: privateKeyApplicationTag,
            kSecReturnRef as String: true,
            kSecAttrAccessGroup as String: keychainAccessGroupName
        ]
    }
}
