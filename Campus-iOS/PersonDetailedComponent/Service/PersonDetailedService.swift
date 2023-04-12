//
//  PersonDetailedService.swift
//  Campus-iOS
//
//  Created by David Lin on 21.01.23.
//

import Foundation

struct PersonDetailedService {
    func fetch(for id: String, token: String, forcedRefresh: Bool) async throws -> PersonDetails {
        let response : PersonDetails = try await MainAPI.makeRequest(endpoint: TUMOnlineAPI.personDetails(identNumber: id), token: token, forcedRefresh: forcedRefresh)
        
        return response
    }
}
