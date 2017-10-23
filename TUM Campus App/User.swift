//
//  User.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/5/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft
import UIKit

final class User {
    
    let token: String
    let lrzID: String?
    var name: String?
    var id: String?
    var data: UserData?
    
    init(lrzID: String, token: String) {
        self.lrzID = lrzID
        self.token = token
    }
    
}
