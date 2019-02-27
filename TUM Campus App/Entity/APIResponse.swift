//
//  Response.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/27/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation

struct Response<ResponseType: Decodable, ErrorType: APIError>: Decodable {
    var response: ResponseType
    
    init(from decoder: Decoder) throws {
        if let error = try? ErrorType(from: decoder) {
            throw error
        } else {
            let response = try ResponseType(from: decoder)
            self.response = response
        }
    }
}

protocol APIError: Error, Decodable {
    
}

struct TUMOnlineError: Decodable {
    var message: String
}


enum TUMOnlineAPIError: APIError {
    case noPermission
    case tokenNotConfirmed
    case invalidToken
    case unkown(String)
    
    enum CodingKeys: String, CodingKey {
        case error = "message"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let error = try container.decode(String.self, forKey: .error)
        
        switch error {
        case let str where str.contains("Keine Rechte für Funktion"):
            self = .noPermission
        case "Token ist nicht bestätigt!":
            self = .invalidToken
        case "Token ist ungültig!":
            self = .invalidToken
        default:
            self = .unkown(error)
        }
    }
}
