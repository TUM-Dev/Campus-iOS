//
//  PersonSearchService.swift
//  Campus-iOS
//
//  Created by David Lin on 21.01.23.
//

import Foundation

struct PersonSearchService {
    func fetch(for query: String, token: String, forcedRefresh: Bool) async throws -> [Person] {
        let response : TUMOnlineAPI2.Response<Person> = try await MainAPI.makeRequest(endpoint: TUMOnlineAPI2.personSearch(search: query), token: token, forcedRefresh: forcedRefresh)
        
        return response.row
    }
}
