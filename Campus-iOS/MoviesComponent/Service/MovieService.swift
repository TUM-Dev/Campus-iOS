//
//  MovieService.swift
//  Campus-iOS
//
//  Created by David Lin on 14.01.23.
//

import Foundation

protocol MovieServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> [Movie]
}

struct MovieService: MovieServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> [Movie] {
        
        return try await TUMCabeAPI.makeRequest(endpoint: .movie, forcedRefresh: forcedRefresh)
    }
}
