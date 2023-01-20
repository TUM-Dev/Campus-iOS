//
//  CalendarService.swift
//  Campus-iOS
//
//  Created by David Lin on 20.01.23.
//

import Foundation

struct CalendarService: ServiceTokenProtocol {
    func fetch(token: String, forcedRefresh: Bool = false) async throws -> [CalendarEvent] {
        let response: CalendarAPIResponse = try await MainAPI.makeRequest(endpoint: TUMOnlineAPI2.calendar, token: token, forcedRefresh: forcedRefresh)
        
        return response.events
    }
}
