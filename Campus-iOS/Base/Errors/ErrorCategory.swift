//
//  ErrorCategory.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 22.12.21.
//

import Foundation

enum ErrorCategory {
    case nonRetryable
    case retryable
    case requiresLogout
}

protocol CategorizedError: Error {
    var category: ErrorCategory { get }
}
