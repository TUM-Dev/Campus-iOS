//
//  MovieService.swift
//  Campus-iOS
//
//  Created by David Lin on 22.01.23.
//

import Foundation

struct MoviesService: ServiceProtocol {
    func fetch(forcedRefresh: Bool = false) async throws -> [Movie] {
        
        let response: [Movie] = try await MainAPI.makeRequest(endpoint: TUMCabeAPI.movie, forcedRefresh: forcedRefresh)
        
        return response
    }
}
