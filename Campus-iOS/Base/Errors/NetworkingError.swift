//
//  NetworkingError.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 22.12.21.
//

import Foundation

enum NetworkingError: LocalizedError {
    case deviceIsOffline
    case unauthorized
    case resourceNotFound
    case serverError(Error)
    case missingData
    case decodingFailed(Error)
    
    public var errorDescription: String? {
        switch self {
        case .deviceIsOffline:
            return "The device appears to be offline, please check the internet connectivity"
        case .unauthorized:
            return "Unauthorized to access the resource"
        case .resourceNotFound:
            return "Resource not found"
        case .serverError(let error):
            return "Server error: \(error.localizedDescription)"
        case .missingData:
            return "The accessed data is missing"
        case .decodingFailed(let error):
            return "Decoding of data failed: \(error.localizedDescription)"
        }
    }
}

extension NetworkingError: CategorizedError {
    var category: ErrorCategory {
        switch self {
        case .deviceIsOffline, .serverError:
            return .retryable
        case .resourceNotFound, .missingData, .decodingFailed:
            return .nonRetryable
        case .unauthorized:
            return .requiresLogout
        }
    }
}
