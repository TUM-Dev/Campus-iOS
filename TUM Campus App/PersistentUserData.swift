//
//  PersistentUserData.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/16/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Sweeft

enum PersistendUserData: StatusSerializable {
    case no
    case some(lrzID: String, token: String)
    
    var serialized: [String : Any] {
        switch self {
        case .no:
            return [:]
        case .some(let lrzID, let token):
            return [
                "lrzID": lrzID,
                "token": token,
            ]
        }
    }
    
    init?(from status: [String : Any]) {
        guard let lrzID = status["lrzID"] as? String,
            let token = status["token"] as? String else {
                
                return nil
        }
        self = .some(lrzID: lrzID, token: token)
    }
    
    var user: User? {
        switch self {
        case .no:
            return nil
        case .some(let lrzID, let token):
            return User(lrzID: lrzID, token: token)
        }
    }
    
}

struct PersistentUser: ObjectStatus {
    static var key: AppDefaults = .login
    static var defaultValue: PersistendUserData = .no
}
