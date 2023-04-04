//
//  PushNotifications.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 29.11.22.
//

import Foundation
import SwiftUI

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
    
    static let DEVICE_TOKEN_KEY = "device_token"
    static let PUSH_NOTIFICATIONS_ENABLED = "push_notifications_enabled"
    static let shared = PushNotifications()
    
    func updatePushNotificationPermission(_ enabled: Bool) {
        if enabled {
            requestPushNotificationPermission(overrideDefaultSettings: true)
        } else {
            unregisterPushNotifications()
        }
    }
    
    /**
    Will be called when the app starts or when a user changes his push notification permission inside the app settings
     - Parameter overrideDefaultSettings: used to check if userdefaults should be overriden. E.g. user defaults should only be overwritten when the user changes
     his permissions manually.
     */
    func requestPushNotificationPermission(overrideDefaultSettings: Bool = false) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if overrideDefaultSettings {
                DispatchQueue.main.async {
                    UserDefaults.standard.set(granted, forKey: PushNotifications.PUSH_NOTIFICATIONS_ENABLED)
                }
            }
            
            /// if the app has notifications enabled but the user disabled notifications in the settings we can unregister from push notifications
            if UserDefaults.standard.bool(forKey: PushNotifications.PUSH_NOTIFICATIONS_ENABLED) && !granted {
                self.unregisterPushNotifications()
            }
            
            if let deviceToken = UserDefaults.standard.string(forKey: PushNotifications.DEVICE_TOKEN_KEY) {
                Task {
                    await self.registerDeviceToken(deviceToken)
                }
            }
        }
    }
    
    func unregisterPushNotifications() {
        Task {
            DispatchQueue.main.async {
                UserDefaults.standard.set(false, forKey: PushNotifications.PUSH_NOTIFICATIONS_ENABLED)
            }
            
            await unregisterDevice()
        }
    }
    
    /**
     Registers the `deviceToken` in the backend to receive push notifications.
     
     - Parameter deviceToken: the current device token
     */
    func registerDeviceToken(_ deviceToken: String) async -> Void {
        do {
            if !UserDefaults.standard.bool(forKey: PushNotifications.PUSH_NOTIFICATIONS_ENABLED) { return }
            
            UserDefaults.standard.set(deviceToken, forKey: PushNotifications.DEVICE_TOKEN_KEY)
            
            let keyPair = try keychain.obtainOrGeneratePublicPrivateKeys()
            
            let device: Api_RegisterDeviceRequest = .with({
                $0.deviceID = deviceToken
                $0.publicKey = keyPair.publicKey
                $0.deviceType = .ios
            })
            
            let _ = try await CampusBackend.shared.registerDevice(device)
        } catch RSAKeyPairError.failedGeneratingPrivateKey(let error)  {
            CrashlyticsService.log("Something went wrong while generating the rsa private key with error message: \(error)")
        } catch RSAKeyPairError.failedObtainingKeyPairFromKeyChain  {
            CrashlyticsService.log("Something went wrong while obtaining the rsa private key")
        } catch RSAKeyPairError.failedObtainingPublicKeyFromPrivateKey {
            CrashlyticsService.log("Something went wrong while obtaining the public key from the private key")
        } catch RSAKeyPairError.failedObtainingExternalRepresentationOfKey(let error) {
            CrashlyticsService.log("Something went wrong while obtaining the external string representation of a key with error message: \(error)")
        } catch RSAKeyPairError.failedToExportPublicKey(let error) {
            CrashlyticsService.log("Something went wrong while exporting the public key with error message: \(error)")
        } catch {
            CrashlyticsService.log("Failed registering ios device token! \(error)")
        }
    }
    
    func unregisterDevice() async {
        do {
            if let deviceToken = UserDefaults.standard.string(forKey: PushNotifications.DEVICE_TOKEN_KEY) {
                let device: Api_RemoveDeviceRequest = .with({
                    $0.deviceID = deviceToken
                    $0.deviceType = .ios
                })
                
                let _ = try await CampusBackend.shared.removeDevice(device)
            }
        } catch {
            CrashlyticsService.log("Failed unregistering ios device! \(error)")
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
            CrashlyticsService.log("Failed responding to push device request because no 'request_id' was defined")
            throw HandlePushDeviceRequestError.noRequestId
        }
        
        guard let notificationType = data["notification_type"] as? String else {
            CrashlyticsService.log("Failed responding to push device request because no 'notification_type' was defined")
            throw HandlePushDeviceRequestError.noNotificationType
        }
        
        switch notificationType {
        case BackgroundNotificationType.campusTokenRequest.rawValue:
            return try await handleCampusTokenRequest(requestId)
        default:
            CrashlyticsService.log("Failed responding to push device request because 'notification_type' was invalid")
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
            CrashlyticsService.log("Failed responding to push device request because no campus token was available")
            throw HandlePushDeviceRequestError.noCampusToken
        }
        
        let response: Api_IOSDeviceRequestResponseRequest = .with({
            $0.payload = campusToken
            $0.requestID = requestId
        })
        
        let _ = try await CampusBackend.shared.iOSDeviceRequestResponse(response)
    }
}
