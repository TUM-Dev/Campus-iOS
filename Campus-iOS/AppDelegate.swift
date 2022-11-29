//
//  AppDelegate.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 29.11.22.
//

import Foundation
import UIKit
import UserNotifications


class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UIApplication.shared.registerForRemoteNotifications()
        registerForPushNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        
        Task {
            await PushNotifications.shared.registerDeviceToken(token)
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications")
        print(error.localizedDescription)
    }
    
    func registerForPushNotifications() {
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
          print("Permission granted: \(granted)")
        }
    }

}
