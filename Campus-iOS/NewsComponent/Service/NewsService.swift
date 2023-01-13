//
//  NewsService.swift
//  Campus-iOS
//
//  Created by David Lin on 13.01.23.
//

import Foundation

protocol NewsServiceProtocol {
    func fetch(forcedRefresh: Bool, source: String) async throws -> [News]
}

struct NewsService: NewsServiceProtocol {
    func fetch(forcedRefresh: Bool, source: String) async throws -> [News] {
        
        return try await TUMCabeAPI.makeRequest(endpoint: .news(source: source), forcedRefresh: forcedRefresh)
    }
}
