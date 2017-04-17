//
//  User.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/5/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft
import UIKit

final class User: ImageDownloader, ImageDownloadSubscriber {
    
    private static var internalSharedUser: User? = nil
    
    static var shared: User? {
        get {
            if internalSharedUser == nil {
                internalSharedUser = PersistentUser.value.user
            }
            return internalSharedUser
        }
        set {
            internalSharedUser = newValue
        }
        
    }
    
    let token: String
    let lrzID: String?
    var name: String?
    var id: String?
    var data: UserData?
    
    init(lrzID: String, token: String) {
        self.lrzID = lrzID
        self.token = token
        super.init()
    }
    
    func getUserData(_ data: UserData) {
        self.data = data
        name = data.name
        id = data.id
        if let image = data.image {
            self.image = image
            notifySubscribers()
        } else {
            data.subscribeToImage(self)
        }
    }
    
    func updateImageView() {
        self.image = data?.image
        notifySubscribers()
    }
    
}
