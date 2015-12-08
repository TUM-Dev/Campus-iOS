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
    var id: String?
    
    init(lrzID: String, token: String) {
        self.lrzID = lrzID
        self.token = token
    }
    
    func getUserData(data: UserData) {
        name = data.name
        id = data.id
        print(data.picture)
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue),0)) {
            if let url = NSURL(string: data.picture), pictureData = NSData(contentsOfURL: url), image = UIImage(data: pictureData) {
                self.picture = image
            }
        }
    }
    
    func getCellIdentifier() -> String {
        return "person"
    }
    
}