//
//  CampusOnlineAPI.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 22.12.21.
//

import Foundation
import Alamofire
import XMLCoder

struct CampusOnlineAPI: NetworkingAPI {    
    static let decoder: XMLDecoder = {
        let decoder = XMLDecoder()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }()
    
    static func makeRequest<T: Decodable>(endpoint: APIConstants, token: String? = nil) async throws -> T {
        var data: Data
        do {
            data = try await endpoint.asRequest(token: token).serializingData().value
        } catch {
            print(error)
            throw NetworkingError.deviceIsOffline
        }
        
        do {
            let decodedData = try Self.decoder.decode(T.self, from: data)
            print(decodedData)
            return decodedData
        } catch {
            let decodedError = try Self.decoder.decode(Error.self, from: data)
            print(error)
            throw decodedError
        }
    }
    
    enum Error: APIError {
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
                return "\("Unkonw error"): \(message)"

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
}
