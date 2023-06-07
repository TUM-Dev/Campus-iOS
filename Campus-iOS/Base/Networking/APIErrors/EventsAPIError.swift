//
//  EventsAPIError.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 07.06.23.
//

import Foundation

enum EventsAPIError: APIError, LocalizedError {
    case unknown(String)
    
    enum CodingKeys: String, CodingKey {
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let error = try container.decode(String.self, forKey: .message)

        switch error {
        default:
            self = .unknown(error)
        }
    }

    init(message: String) {
        self = .unknown(message)
    }
    
    public var errorDescription: String? {
        switch self {
        case let .unknown(message):
            return "\("Unkonw error".localized): \(message)"
        }
    }
}
