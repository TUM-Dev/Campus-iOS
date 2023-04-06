//
//  NewsService.swift
//  Campus-iOS
//
//  Created by David Lin on 13.01.23.
//

import Foundation

protocol NewsServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> [NewsSource]
    
    func fetch(forcedRefresh: Bool, source: String) async throws -> [News]
}

struct NewsService: ServiceProtocol, NewsServiceProtocol {
    func fetch(forcedRefresh: Bool = false) async throws -> [NewsSource] {
        
        var newsSourceResponse: [NewsSource] = try await MainAPI.makeRequest(endpoint: TUMCabeAPI.newsSources, forcedRefresh: forcedRefresh)
        
        for i in newsSourceResponse.indices {
            guard let idDescription = newsSourceResponse[i].id?.description else {
                break
            }
            
            let news: [News] = try await MainAPI.makeRequest(endpoint: TUMCabeAPI.news(source: String(idDescription)))
            
            newsSourceResponse[i].news = news
        }
        
        return newsSourceResponse
    }
    
    func fetch(forcedRefresh: Bool, source: String) async throws -> [News] {
        let news: [News] = try await MainAPI.makeRequest(endpoint: TUMCabeAPI.news(source: "1"))
        
        return news
    }
}
