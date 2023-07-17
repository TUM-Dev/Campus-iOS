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

struct MovieService: ServiceProtocol, MovieServiceProtocol {
    func fetch(forcedRefresh: Bool = false) async throws -> [Movie] {
        
        let response: [Movie] = try await MainAPI.makeRequest(endpoint: TUMCabeAPI.movie, forcedRefresh: forcedRefresh)
        
        return response
    }
}
