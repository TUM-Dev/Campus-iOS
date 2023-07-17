//
//  File.swift
//  Campus-iOS
//
//  Created by David Lin on 05.05.23.
//

import Foundation

enum SearchState<T: Searchable> {
    case na
    case loading
    case success(data: [(T, Distances)])
    case failed(error: Error)
}
