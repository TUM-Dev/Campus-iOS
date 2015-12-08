//
//  User.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/5/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import UIKit
class User:ImageDownloader {
    let token: String
    let lrzID: String?
    var name: String?
    var id: String?
    
    init(lrzID: String, token: String) {
        self.lrzID = lrzID
        self.token = token
        super.init()
    }
    
    func getUserData(data: UserData) {
        name = data.name
        id = data.id
        getImage(data.picture)
    }
    
}