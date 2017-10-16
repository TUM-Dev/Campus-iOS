//
//  PersistentUserData.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/16/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Sweeft

enum PersistendUserData: Codable {
    
    enum CodingKeys: String, CodingKey {
        case lrzID
        case token
    }
    
    case no
    case some(lrzID: String, token: String)
    
    var user: User? {
        switch self {
        case .no:
            return nil
        case .some(let lrzID, let token):
            return User(lrzID: lrzID, token: token)
        }
    }
    
    
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let lrzID = try container.decode(String.self, forKey: .lrzID)
            let token = try container.decode(String.self, forKey: .token)
            self = .some(lrzID: lrzID, token: token)
        } catch {
            self = .no
        }
    }
    
    func encode(to encoder: Encoder) throws {
        switch self {
        case .no:
            let dict = [String : String]()
            var container = encoder.singleValueContainer()
            try container.encode(dict)
        case .some(let lrzID, let token):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(lrzID, forKey: .lrzID)
            try container.encode(token, forKey: .token)
        }
    }
    
}

struct PersistentUser: SingleStatus {
    static var key: AppDefaults = .login
    static var defaultValue: PersistendUserData = .no
}
