//
//  TUMOnlineAPIError.swift
//  Campus-iOS
//
//  Created by David Lin on 10.02.23.
//

import Foundation

enum TUMOnlineAPIError: APIError, LocalizedError {
    case noPermission
    case tokenNotConfirmed
    case invalidToken
    case unknown(String)
    
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
            self = .unknown(error)
        }
    }

    init(message: String) {
        self = .unknown(message)
    }
    
    public var errorDescription: String? {
        switch self {
        case .noPermission:
            return "No Permission".localized
        case .tokenNotConfirmed:
            return "Token not confirmed".localized
        case .invalidToken:
            return "Token invalid".localized
        case let .unknown(message):
            return "\("Unkonw error".localized): \(message)"

        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .noPermission:
            return "Make sure to enable the right permissions for your token.".localized
        case .tokenNotConfirmed:
            return "Go to TUMonline and confirm your token.".localized
        case .invalidToken:
            return "Try creating a new token.".localized
        default:
            return nil
        }
    }
}
