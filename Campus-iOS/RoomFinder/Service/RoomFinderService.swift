//
//  RoomFinderService.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 01.01.23.
//

import Foundation

protocol RoomFinderServiceProtocol {
    func search(query: String) async throws -> NavigaTumSearchResponse
    func details(id: String) async throws -> NavigaTumNavigationDetails
    func fetch(for query: String, forcedRefresh: Bool) async throws -> [FoundRoom]
}

struct RoomFinderService: RoomFinderServiceProtocol {
    
    func search(query: String) async throws -> NavigaTumSearchResponse {
        return try await MainAPI.makeRequest(endpoint: NavigaTUMAPI.search(query: query))
    }
    
    func details(id: String) async throws -> NavigaTumNavigationDetails {
        let language = (Locale.current.language.languageCode?.identifier == "de") ? "de" : "en"
        
        return try await MainAPI.makeRequest(endpoint: NavigaTUMAPI.details(id: id, language: language))
    }
    
    func fetch(for query: String, forcedRefresh: Bool) async throws -> [FoundRoom] {
        let response : [FoundRoom] = try await MainAPI.makeRequest(endpoint: TUMCabeAPI.roomSearch(query: query))
        
        return response
    }
}
