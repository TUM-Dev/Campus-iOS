//
//  NotificationService.swift
//  NotificationService
//
//  Created by Anton Wyrowski on 13.12.22.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    private final let keychain: KeychainService = KeychainService()
    
    /**
     Called before the push notification is displayed to the user
     */
    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler:
        @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent else {
            return
        }
            
        func shouldNotHappen(_ error: String = "") {
            bestAttemptContent.title = "Encrypted Notification Payload 🚨"
            bestAttemptContent.subtitle = "Message our support if that happens again."
            bestAttemptContent.body = error
            
            contentHandler(bestAttemptContent)
        }
        
        guard let privateKey = keychain.optionalOptainPrivateKey() else {
            return shouldNotHappen("Encryption key does not exist in KeyChain")
        }
        
        if bestAttemptContent.title != "" {
            let plainText = keychain.decrypt(cipherText: bestAttemptContent.title, privateKey: privateKey)

            bestAttemptContent.title = plainText ?? "Decryption Error"
        }
        
        if bestAttemptContent.subtitle != "" {
            let plainText = keychain.decrypt(cipherText: bestAttemptContent.subtitle, privateKey: privateKey)

            bestAttemptContent.subtitle = plainText ?? "Decryption Error"
        }
        
        if bestAttemptContent.body != "" {
            let plainText = keychain.decrypt(cipherText: bestAttemptContent.body, privateKey: privateKey)

            bestAttemptContent.body = plainText ?? "Decryption Error"
        }
        
        contentHandler(bestAttemptContent)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
