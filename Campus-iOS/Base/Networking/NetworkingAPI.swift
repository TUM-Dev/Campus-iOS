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
    static var cache: Cache<String, Decodable> { get }
    
    static func makeRequest<T: Decodable>(endpoint: APIConstants, token: String?, forcedRefresh: Bool) async throws -> T
}
