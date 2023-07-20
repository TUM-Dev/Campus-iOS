//
//  SearchError.swift
//  Campus-iOS
//
//  Created by David Lin on 07.03.23.
//

import Foundation

enum SearchError: Error, CustomStringConvertible{
    case empty(searchQuery: String)
    case unexpected
    
    public var description: String {
        switch self {
        case .empty(let searchQuery):
            return "No search results were found for: \"\(searchQuery)\"."
        case .unexpected:
            return "An unexpected error occurred."
        }
    }
}
    
