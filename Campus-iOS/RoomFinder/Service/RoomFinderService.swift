//
//  RoomFinderService.swift
//  Campus-iOS
//
//  Created by David Lin on 06.04.23.
//

import Foundation

struct RoomFinderSearchService {
    func fetch(for query: String, forcedRefresh: Bool) async throws -> [FoundRoom] {
        let response : [FoundRoom] = try await MainAPI.makeRequest(endpoint: TUMCabeAPI.roomSearch(query: query))
        
        return response
    }
}
