//
//  User.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/5/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import UIKit
class User {
    let token: String
    let lrzID: String
    var name: String?
    var picture: UIImage?
    
    init(lrzID: String, token: String) {
        self.lrzID = lrzID
        self.token = token
    }
    
}