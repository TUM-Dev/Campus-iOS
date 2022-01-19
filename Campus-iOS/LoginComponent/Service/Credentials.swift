//
//  Credentials.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/15/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import KeychainAccess


enum Credentials: Codable, Equatable {
    case noTumID
    case tumID(tumID: String, token: String)
    case tumIDAndKey(tumID: String, token: String, key: Data)

    enum CodingKeys: CodingKey {
        case tumID
        case token
        case key
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let tumID = try container.decodeIfPresent(String.self, forKey: .tumID)
        let token = try container.decodeIfPresent(String.self, forKey: .token)
        let key = try container.decodeIfPresent(Data.self, forKey: .key)
        
        switch (tumID,token,key) {
        case (.some(let tumID),.some(let token),.some(let key)): self = .tumIDAndKey(tumID: tumID, token: token, key: key)
        case (.some(let tumID),.some(let token),.none): self = .tumID(tumID: tumID, token: token)
        default: self = .noTumID
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .tumID(let tumID, let token):
            try container.encode(tumID, forKey: .tumID)
            try container.encode(token, forKey: .token)
        case .tumIDAndKey(let tumID, let token, let key):
            try container.encode(tumID, forKey: .tumID)
            try container.encode(token, forKey: .token)
            try container.encode(key, forKey: .key)
        default: break
        }
    }
}
