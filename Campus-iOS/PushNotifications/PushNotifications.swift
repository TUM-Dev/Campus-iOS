//
//  PushNotifications.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 29.11.22.
//

import Foundation

class PushNotifications {
    
    static let shared = PushNotifications()
    
    func registerDeviceToken(_ deviceToken: String) async -> Void {
        print("Registering token \(deviceToken)")
        
        let device: Api_RegisterIOSDeviceRequest = .with({
            $0.deviceID = deviceToken
        })
        
        do {
            print("Sending device id to server")
            let _ = try await CampusBackend.shared.registerIOSDevice(device)
        } catch {
            print("Failed registering ios device token!")
        }
        
    }
}
