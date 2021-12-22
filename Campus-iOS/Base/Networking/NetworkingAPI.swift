//
//  NetworkingAPI.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 22.12.21.
//

import Foundation
import Combine

protocol NetworkingAPI {
    associatedtype Decoder: TopLevelDecoder
    static var decoder: Decoder { get }
    
    static func makeRequest<T: Decodable>(endpoint: APIConstants, token: String?) async throws -> T
}
