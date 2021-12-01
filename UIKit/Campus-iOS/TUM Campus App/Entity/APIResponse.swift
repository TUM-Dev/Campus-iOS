//
//  APIResponse.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/27/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

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

struct TUMOnlineAPIResponse<T: Decodable>: Decodable {
    var rows: [T]?

    enum CodingKeys: String, CodingKey {
        case rows = "row"
    }

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.rows = try container.decode([Throwable<T>].self, forKey: .rows).compactMap {
        do {
          return try $0.result.get()
        }
        catch {
          Crashlytics.crashlytics().record(error: error)
          return nil
        }
      }
    }
}

struct Throwable<T: Decodable>: Decodable {
  let result: Result<T, Error>

  init(from decoder: Decoder) throws {
    result = Result(catching: { try T(from: decoder) })
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
            return "No Permission".localized
        case .tokenNotConfirmed:
            return "Token not confirmed".localized
        case .invalidToken:
            return "Token invalid".localized
        case let .unkown(message):
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


enum TUMCabeAPIError: APIError, LocalizedError {
    case unkown(String)

    enum CodingKeys: String, CodingKey {
        case message
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let error = try container.decode(String.self, forKey: .message)

        switch error {
        default:
            self = .unkown(error)
        }
    }

    public var errorDescription: String? {
        switch self {
        case let .unkown(message):
            return "\("Unkonw error".localized): \(message)"
        }
    }
}

