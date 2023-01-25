//
//  NotificationService.swift
//  NotificationService
//
//  Created by Anton Wyrowski on 13.12.22.
//

import UserNotifications

enum RSAKeyPairError: Error {
    case failedObtainingPrivateKeyFromKeyChain
    case failedObtainingStringRepresentationOfPrivateKey
}


class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    private static let privateKeyApplicationTag = "de.tum.tca.keys.push_rsa_key"
    private static let keychainAccessGroupName = "2J3C6P6X3N.de.tum.tca.notificationextension"
    
    private var privateKeyKeychainQuery: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrKeySizeInBits as String: 2048,
                kSecAttrApplicationTag as String: privateKeyApplicationTag,
                kSecReturnRef as String: true,
                kSecAttrAccessGroup as String: NotificationService.keychainAccessGroupName
            ]

    /**
     Called before the push notification is displayed to the user
     */
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            
            let exists = checkIfPrivateKeyAlreadyExists()
            
            func shouldNotHappen(_ error: String = "") {
                bestAttemptContent.title = "Encrypted Notification Payloud 🚨"
                bestAttemptContent.subtitle = "Message our support if that happens again."
                bestAttemptContent.body = error
                
                contentHandler(bestAttemptContent)
            }
            
            if !exists {
                return shouldNotHappen("Encryption key does not exist in KeyChain")
            }
            
            do {
                let privateKey = try obtainRawPrivateKeyFromKeyChain()
                
                if bestAttemptContent.title != "" {
                    let plainText = decrypt(cipherText: bestAttemptContent.title, privateKey: privateKey)
    
                    bestAttemptContent.title = plainText ?? "Decryption Error"
                }
                
                if bestAttemptContent.subtitle != "" {
                    let plainText = decrypt(cipherText: bestAttemptContent.subtitle, privateKey: privateKey)
    
                    bestAttemptContent.subtitle = plainText ?? "Decryption Error"
                }
                
                if bestAttemptContent.body != "" {
                    let plainText = decrypt(cipherText: bestAttemptContent.body, privateKey: privateKey)
    
                    bestAttemptContent.body = plainText ?? "Decryption Error"
                }
                
                contentHandler(bestAttemptContent)
            } catch {
                shouldNotHappen("Something went wrong decrypting the push notification content. Error: \(error)")
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    /**
     Decrypts a given `cipherText` using the RSA `privateKey`
     
     - Parameters:
        - cipherText: Encrypted text that should be decrypted
        - privateKey: RSA PrivateKey from the keychain
     
     */
    private func decrypt(cipherText: String, privateKey: SecKey) -> String? {
        let cipherData = Data(base64Encoded: cipherText)! as CFData
        
        var error: Unmanaged<CFError>?
        let plaintext = SecKeyCreateDecryptedData(privateKey, .rsaEncryptionOAEPSHA256, cipherData, &error)
        
        guard plaintext != nil else {
            return nil
        }
        
        let data: NSData = plaintext!
        
        return String(data: data as Data, encoding: .utf8)
    }
    
    private func checkIfPrivateKeyAlreadyExists() -> Bool {
        do {
            let _ = try obtainPrivateKeyFromKeyChain()
        } catch {
            return false
        }
        
        return true
    }
    
    private func obtainRawPrivateKeyFromKeyChain() throws -> SecKey {
        var item: CFTypeRef?
        let status = SecItemCopyMatching(privateKeyKeychainQuery as CFDictionary, &item)
        
        guard status == errSecSuccess && item != nil else {
            throw RSAKeyPairError.failedObtainingPrivateKeyFromKeyChain
        }
        
        return item as! SecKey
    }
    
  
    private func obtainPrivateKeyFromKeyChain() throws -> String {
        let privateKey = try obtainRawPrivateKeyFromKeyChain()
        
        var error: Unmanaged<CFError>?
        guard let privateERData = SecKeyCopyExternalRepresentation(privateKey, &error) else {
            throw RSAKeyPairError.failedObtainingStringRepresentationOfPrivateKey
        }
        
        let privateData: Data = privateERData as Data
        
        return privateData.base64EncodedString()
    }

}
