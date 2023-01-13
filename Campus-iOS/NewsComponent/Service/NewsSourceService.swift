//
//  NewsService.swift
//  Campus-iOS
//
//  Created by David Lin on 13.01.23.
//

import Foundation

protocol NewsSourceServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> [NewsSource]
}

struct NewsSourceService: NewsSourceServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> [NewsSource] {
        
        return try await TUMCabeAPI.makeRequest(endpoint: .newsSources, forcedRefresh: forcedRefresh)
    }
}

