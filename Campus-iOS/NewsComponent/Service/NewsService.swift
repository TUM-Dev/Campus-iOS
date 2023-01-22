//
//  NewsService.swift
//  Campus-iOS
//
//  Created by David Lin on 22.01.23.
//

import Foundation

struct NewsService: ServiceProtocol {
    func fetch(forcedRefresh: Bool = false) async throws -> [NewsSource] {
        
        let newsSourceResponse: [NewsSource] = try await MainAPI.makeRequest(endpoint: TUMCabeAPI2.newsSources, forcedRefresh: forcedRefresh)
        
        for i in newsSourceResponse.indices {
            guard let idDescription = newsSourceResponse[i].id?.description else {
                break
            }
            
            let news: [News] = try await MainAPI.makeRequest(endpoint: TUMCabeAPI2.news(source: String(idDescription)))
            
            newsSourceResponse[i].news = news
        }
        
        return newsSourceResponse
    }
}
