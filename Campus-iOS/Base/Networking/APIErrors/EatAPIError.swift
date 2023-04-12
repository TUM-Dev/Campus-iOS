//
//  EatAPIError.swift
//  Campus-iOS
//
//  Created by David Lin on 10.02.23.
//

import Foundation

enum EatAPIError: APIError, LocalizedError {
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
