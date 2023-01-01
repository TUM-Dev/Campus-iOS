//
//  RoomFinderService.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 01.01.23.
//

import Foundation
import Alamofire

protocol RoomFinderServiceProtocol {
    func search(query: String, forcedRefresh: Bool) async throws -> [NavigaTumSearchResponse]
    func details(id: String, forcedRefresh: Bool) async throws -> [NavigationDetails]
}

struct RoomFinderService: RoomFinderServiceProtocol {
    func search(query: String, forcedRefresh: Bool = false) async throws -> [NavigaTumSearchResponse] {
        try await
            CampusOnlineAPI
                .makeRequest(
                    endpoint: Constants.API.NavigaTum.search(query: query),
                    forcedRefresh: forcedRefresh
                )
    }
    
    func details(id: String, forcedRefresh: Bool) async throws -> [NavigationDetails] {
        let language = (Locale.current.languageCode == "de") ? "de" : "en"
        
        return try await
            CampusOnlineAPI
                .makeRequest(
                    endpoint: Constants.API.NavigaTum.details(id: id, language: language),
                    forcedRefresh: forcedRefresh
                )
    }
}
