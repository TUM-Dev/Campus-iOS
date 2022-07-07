//
//  NetworkingAPI.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 22.12.21.
//

import Foundation
import Combine

protocol NetworkingAPI {
    // Renaming to `DecoderType` as we otherwise have a conflict between the `Decoder` associatedtype of `Decodable` and the `Decoder` associatedtype of `NetworkingAPI`
    associatedtype DecoderType: TopLevelDecoder
    static var decoder: DecoderType { get }
    static var cache: Cache<String, Decodable> { get }
    
    static func makeRequest<T: Decodable>(endpoint: APIConstants, token: String?, forcedRefresh: Bool) async throws -> T
}
