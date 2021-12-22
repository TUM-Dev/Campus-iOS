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
