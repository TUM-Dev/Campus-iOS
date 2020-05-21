//
//  APIResponse.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/27/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation

struct APIResponse<ResponseType: Decodable, ErrorType: APIError>: Decodable {
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

protocol APIError: Error, Decodable { }

enum TUMOnlineAPIError: APIError, LocalizedError {
    case noPermission
    case tokenNotConfirmed
    case invalidToken
    case unkown(String)
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let error = try container.decode(String.self, forKey: .message)
        
        switch error {
        case let str where str.contains("Keine Rechte für Funktion"):
            self = .noPermission
        case "Token ist nicht bestätigt!":
            self = .tokenNotConfirmed
        case "Token ist ungültig!":
            self = .invalidToken
        default:
            self = .unkown(error)
        }
    }

    public var errorDescription: String? {
        switch self {
        case .noPermission:
            return "No Permission"
        case .tokenNotConfirmed:
            return "Token not confirmed"
        case .invalidToken:
            return "Token invalid"
        case let .unkown(message):
            return "Unkonw error: \(message)"

        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .noPermission:
            return "Make sure to enable the right permissions for your token."
        case .tokenNotConfirmed:
            return "Go to TUMonline and confirm your token."
        case .invalidToken:
            return "Try creating a new token."
        default:
            return nil
        }
    }
}
