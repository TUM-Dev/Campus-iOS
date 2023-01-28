//
//  PushNotifications.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 29.11.22.
//

import Foundation

enum HandlePushDeviceRequestError: Error {
    case noCampusToken
    case noRequestId
    case noNotificationType
    case invalidNotificationType
}

enum BackgroundNotificationType: String {
    case campusTokenRequest = "CAMPUS_TOKEN_REQUEST"
}

/**
 Integrates keychain management, including generating and storing of public and private RSA keys.
 Handles registering the device id in the backend, responding to background notifications and reading the Campus API Token from the keychain.
 
 The `PushNotification` class can be used as singleton by accessing the static `shared` property.
 */
class PushNotifications {
    private final let keychain: KeychainService = KeychainService()
    
    static let shared = PushNotifications()
    
    /**
    Registers the `deviceToken` in the backend to receive push notifications.
     
     - Parameter deviceToken: the current device token
     */
    func registerDeviceToken(_ deviceToken: String) async -> Void {
        do {
            let keyPair = try keychain.getPublicPrivateKeys()
            
            let device: Api_RegisterDeviceRequest = .with({
                $0.deviceID = deviceToken
                $0.publicKey = keyPair.publicKey
                $0.deviceType = .ios
            })
            
            print(keyPair.publicKey)
            
            let _ = try await CampusBackend.shared.registerDevice(device)
        } catch RSAKeyPairError.failedGeneratingPrivateKey  {
            print("Something went wrong while generating the rsa private key")
        } catch RSAKeyPairError.failedObtainingKeyPairFromKeyChain  {
            print("Something went wrong while obtaining the rsa private key")
        } catch {
            print("Failed registering ios device token! \(error)")
        }
        
    }
    
    /**
     Handles incoming background notification requests from the backend.
     
     - Throws:
        - `HandlePushDeviceRequestError.noRequestId`: if  the push notification body does not contain the `request_id` parameter
        - `HandlePushDeviceRequestError.noNotificationType`: if if  the push notification body does not contain the `notification_type` parameter
        - `HandlePushDeviceRequestError.invalidNotificationType`: if the `notification_type` is other then `BackgroundNotificationType`
        
     - Parameter data: the background notification body
     */
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
        case BackgroundNotificationType.campusTokenRequest.rawValue:
            return try await handleCampusTokenRequest(requestId)
        default:
            print("Failed responding to push device request because 'notification_type' was invalid")
            throw HandlePushDeviceRequestError.invalidNotificationType
        }
    }
    
    /**
     Handles a `BackgroundNotificationType.campusTokenRequest`.
     Reads the `campusToken` from the keychain and sends it to the backend including the `requestId`.
     
     - Parameter requestId: identifies the background notification request in the backend and needs to be transmitted with the campus token
     - Throws: `HandlePushDeviceRequestError.noCampusToken` if the campus token cannot be read from the keychain
     */
    private func handleCampusTokenRequest(_ requestId: String) async throws {
        guard let campusToken = keychain.campusToken else {
            print("Failed responding to push device request because no campus token was available")
            throw HandlePushDeviceRequestError.noCampusToken
        }
        
        let response: Api_IOSDeviceRequestResponseRequest = .with({
            $0.payload = campusToken
            $0.requestID = requestId
        })
        
        let _ = try await CampusBackend.shared.iOSDeviceRequestResponse(response)
    }
}
