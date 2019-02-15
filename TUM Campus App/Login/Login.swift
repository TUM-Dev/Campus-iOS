//
//  Login.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/15/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import KeychainAccess


enum Login: Codable {
    case noTumID
    case tumID(tumID: String, token: String, key: Data)
    
    enum CodingKeys: CodingKey {
        case tumID
        case token
        case key
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let tumID = try container.decodeIfPresent(String.self, forKey: .tumID),
            let token = try container.decodeIfPresent(String.self, forKey: .token),
            let key = try container.decodeIfPresent(Data.self, forKey: .key) {
            self = .tumID(tumID: tumID, token: token, key: key)
        } else {
            self = .noTumID
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .tumID(let tumID, let token, let key):
            try container.encode(tumID, forKey: .tumID)
            try container.encode(token, forKey: .token)
            try container.encode(key, forKey: .key)
        default: break
        }
    }
    
    static func fromKeychain() -> Login? {
        // TODO read data from keychain
        return .tumID(tumID: "foo", token: "bar", key: Data())
    }

}
