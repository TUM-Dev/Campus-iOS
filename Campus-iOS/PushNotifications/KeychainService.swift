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
    case failedGeneratingPrivateKey(_ error: String)
    case failedObtainingKeyPairFromKeyChain
    case failedObtainingPublicKeyFromPrivateKey
    case failedObtainingExternalRepresentationOfKey(_ error: String)
    case failedToExportPublicKey(_ error: String)
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
    func obtainOrGeneratePublicPrivateKeys() throws -> RSAKeyPair {
        guard let privateKey = optionalOptainPrivateKey() else {
            try generatePrivateKey()
            
            return try obtainPublicPrivateKey()
        }
        
        let publicKey = try obtainPublicKey(privateKey)
        
        return try publicPrivateKeyToValidFormat(publicKey: publicKey, privateKey: privateKey)
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
                kSecAttrApplicationTag as String: privateKeyApplicationTag,
            ],
            kSecAttrAccessGroup as String: keychainAccessGroupName,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        var error: Unmanaged<CFError>?
        guard SecKeyCreateRandomKey(attributes as CFDictionary, &error) != nil else {
            throw RSAKeyPairError.failedGeneratingPrivateKey(error.debugDescription)
        }
    }
    
    
    func optionalOptainPrivateKey() -> SecKey? {
        do {
            return try obtainPrivateKey()
        } catch {
            return nil
        }
    }
    
    /**
     Tries to query for the private key using the `privateKeyKeychainQuery`
     */
    func obtainPrivateKey() throws -> SecKey {
        var item: CFTypeRef?
        let status = SecItemCopyMatching(privateKeyQuery as CFDictionary, &item)
        
        guard status == errSecSuccess && item != nil && CFGetTypeID(item) == SecKeyGetTypeID() else {
            throw RSAKeyPairError.failedObtainingKeyPairFromKeyChain
        }
        
        return item as! SecKey
    }
    
    func obtainPrivateKey() throws -> String {
        let privateKey: SecKey = try obtainPrivateKey()
        
        let privateData = try getExternalRepresenation(privateKey)
        
        return exportPrivateKeyAsValidString(privateData)
    }
    
    /**
     Obtains the private key from the keychain, creates a public key from the private key and finally returns an external representation for the keys.
     */
    private func obtainPublicPrivateKey() throws -> RSAKeyPair {
        let privateKey: SecKey = try obtainPrivateKey()
                
        let publicKey = try obtainPublicKey(privateKey)
        
        return try publicPrivateKeyToValidFormat(publicKey: publicKey, privateKey: privateKey)
    }
    
    
    /**
     Creates an external representation for both the `publicKey` and the `privateKey`
     */
    private func publicPrivateKeyToValidFormat(publicKey: SecKey, privateKey: SecKey) throws -> RSAKeyPair {
       let privateData = try getExternalRepresenation(privateKey)
        
        let publicData = try getExternalRepresenation(publicKey)
        
        return (exportPrivateKeyAsValidString(privateData), exportPublicKeyAsValidPEM(publicData))
    }
    
    private func getExternalRepresenation(_ key: SecKey) throws -> Data {
        var error: Unmanaged<CFError>?
        guard let keyERData = SecKeyCopyExternalRepresentation(key, &error) else {
            throw RSAKeyPairError.failedObtainingExternalRepresentationOfKey(error.debugDescription)
        }
        
        return keyERData as Data
    }
    
    private func exportPrivateKeyAsValidString(_ privateKey: Data) -> String {
        return privateKey.base64EncodedString()
    }
    
    /**
     Uses `CryptoExportImportManager` to export the public key in a format (PEM) that can be read by the backend
     */
    private func exportPublicKeyAsValidPEM(_ publicKey: Data) -> String {
        let exportManager = CryptoExportImportManager()
        
        return exportManager.exportRSAPublicKeyToPEM(publicKey, keyType: keyType, keySize: keySize)
    }
    
    /**
        Generates a public key, from a `privateKey`
     */
    private func obtainPublicKey(_ privateKey: SecKey) throws -> SecKey {
        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            throw RSAKeyPairError.failedObtainingPublicKeyFromPrivateKey
        }
        
        return publicKey
    }
    
    /**
     Decrypts a given `cipherText` using the RSA `privateKey`
     
     - Parameters:
        - cipherText: Encrypted text that should be decrypted
        - privateKey: RSA PrivateKey from the keychain
     
     */
    func decrypt(cipherText: String, privateKey: SecKey) -> String? {
        guard let cipherData = Data(base64Encoded: cipherText) else {
            return nil
        }
        
        var error: Unmanaged<CFError>?
        let plaintext = SecKeyCreateDecryptedData(privateKey, .rsaEncryptionOAEPSHA256, cipherData as CFData, &error)
        
        guard let data: NSData = plaintext else {
            return nil
        }
        
        return String(data: data as Data, encoding: .utf8)
    }
    
    private var privateKeyQuery: [String: Any] {
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
