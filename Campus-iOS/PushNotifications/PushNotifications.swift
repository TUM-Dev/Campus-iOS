//
//  PushNotifications.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 29.11.22.
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

enum HandlePushDeviceRequestError: Error {
    case noCampusToken
    case noRequestId
    case noNotificationType
    case invalidNotificationType
}

class PushNotifications {
    
    private static let privateKeyApplicationTag = "de.tum.tca.keys.push_public_key"
    private static let keychainAccessGroupName = "2J3C6P6X3N.de.tum.tca.notificationextension"
    private static let keyType = kSecAttrKeyTypeRSA as String
    private static let keySize = 2048
    private static let keychain = Keychain(service: "de.tum.campusapp")
        .synchronizable(true)
        .accessibility(.afterFirstUnlock)
    
    static let shared = PushNotifications()
    
    func registerDeviceToken(_ deviceToken: String) async -> Void {
        do {
            let keyPair = try getPublicPrivateKeys()
            
            let device: Api_RegisterDeviceRequest = .with({
                $0.deviceID = deviceToken
                $0.publicKey = keyPair.publicKey
                $0.deviceType = .ios
            })
            
            let response = try await CampusBackend.shared.registerDevice(device)
        } catch RSAKeyPairError.failedGeneratingPrivateKey  {
            print("Something went wrong while generating the rsa private key")
        } catch RSAKeyPairError.failedObtainingKeyPairFromKeyChain  {
            print("Something went wrong while obtaining the rsa private key")
        } catch {
            print("Failed registering ios device token! \(error)")
        }
        
    }
    
    func handleBackgroundNotification(data: [AnyHashable : Any]) async throws {
        guard let requestId = data["request_id"] as? String else {
            print("Failed responding to push device request because no 'request_id' was defined")
            throw HandlePushDeviceRequestError.noRequestId
        }
        
        guard let notificationType = data["notification_type"] as? String else {
            print("Failed responding to push device request because no 'notification_type' was defined")
            throw HandlePushDeviceRequestError.noNotificationType
        }
        
        switch notificationType {
        case "CAMPUS_TOKEN_REQUEST":
            return try await handleCampusTokenRequest(requestId)
        default:
            print("Failed responding to push device request because 'notification_type' was invalid")
            throw HandlePushDeviceRequestError.invalidNotificationType
        }
    }
    
    private func handleCampusTokenRequest(_ requestId: String) async throws {
        guard let campusToken = self.campusToken else {
            print("Failed responding to push device request because no campus token was available")
            throw HandlePushDeviceRequestError.noCampusToken
        }
        
        let response: Api_IOSDeviceRequestResponseRequest = .with({
            $0.payload = campusToken
            $0.requestID = requestId
        })
        
        let res = try await CampusBackend.shared.iOSDeviceRequestResponse(response)
    }
    
    private var campusToken: String? {
        switch credentials {
        case .none, .noTumID:
            return nil
        case .tumID(_, let token):
            return token
        case .tumIDAndKey(_, let token, _):
            return token
        }
    }
    
    private var credentials: Credentials? {
        guard let data = PushNotifications.keychain[data: "credentials"] else { return nil }
        return try? PropertyListDecoder().decode(Credentials.self, from: data)
    }
    
    private func getPublicPrivateKeys() throws -> RSAKeyPair {
        if checkIfPrivateKeyAlreadyExists() {
            return try obtainPublicPrivateKeyFromKeyChain()
        }
        
        try generatePrivateKeys()
        
        return try obtainPublicPrivateKeyFromKeyChain()
    }
    
    private func exportPublicKeyAsValidPEM(_ publicKey: Data) -> String {
        let exportManager = CryptoExportImportManager()
        
        return exportManager.exportRSAPublicKeyToPEM(publicKey, keyType: PushNotifications.keyType, keySize: PushNotifications.keySize)
    }
    
    private func generatePrivateKeys() throws {
        let attributes: [String: Any] = [
                kSecAttrKeyType as String: kSecAttrKeyTypeEC,
                kSecAttrKeySizeInBits as String: 2048,
                kSecPrivateKeyAttrs as String: [
                    kSecAttrIsPermanent as String: true,
                    kSecAttrApplicationTag as String: PushNotifications.privateKeyApplicationTag
                ],
                kSecAttrAccessGroup as String: PushNotifications.keychainAccessGroupName
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
    
    private func obtainPrivateKeyFromKeyChain() throws -> SecKey {
        var item: CFTypeRef?
        let status = SecItemCopyMatching(privateKeyKeychainQuery as CFDictionary, &item)
        
        guard status == errSecSuccess && item != nil else {
            throw RSAKeyPairError.failedObtainingKeyPairFromKeyChain
        }
        
        return item as! SecKey
    }
    
  
    private func obtainPublicPrivateKeyFromKeyChain() throws -> RSAKeyPair {
        let privateKey = try obtainPrivateKeyFromKeyChain()
                
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
    
    private var privateKeyKeychainQuery: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
                kSecAttrKeyType as String: PushNotifications.keyType,
                kSecAttrKeySizeInBits as String: PushNotifications.keySize,
                kSecAttrApplicationTag as String: privateKeyApplicationTag,
                kSecReturnRef as String: true,
                kSecAttrAccessGroup as String: PushNotifications.keychainAccessGroupName
            ]
    
    
}
