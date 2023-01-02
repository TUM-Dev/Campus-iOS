//
//  RoomFinderService.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 01.01.23.
//

import Foundation
import Alamofire

protocol RoomFinderServiceProtocol {
    func search(query: String) async throws -> [NavigaTumSearchResponse]
    func details(id: String) async throws -> [NavigaTumNavigationDetails]
}

struct RoomFinderService: RoomFinderServiceProtocol {
    func search(query: String) async throws -> [NavigaTumSearchResponse] {
        try await
            NavigaTumAPI
                .makeRequest(
                    endpoint: Constants.API.NavigaTum.search(query: query)
                )
    }
    
    func details(id: String) async throws -> [NavigaTumNavigationDetails] {
        let language = (Locale.current.languageCode == "de") ? "de" : "en"
        
        return try await
            NavigaTumAPI
                .makeRequest(
                    endpoint: Constants.API.NavigaTum.details(id: id, language: language)
                )
    }
}
