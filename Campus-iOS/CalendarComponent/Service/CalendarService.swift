//
//  CalendarService.swift
//  Campus-iOS
//
//  Created by David Lin on 20.01.23.
//

import Foundation

protocol CalendarServiceProtocol {
    func fetch(token: String, forcedRefresh: Bool) async throws -> [CalendarEvent]
}

struct CalendarService: ServiceTokenProtocol, CalendarServiceProtocol {
    
    func fetch(token: String, forcedRefresh: Bool = false) async throws -> [CalendarEvent] {
        let response: TUMOnlineAPI.CalendarResponse = try await MainAPI.makeRequest(endpoint: TUMOnlineAPI.calendar, token: token, forcedRefresh: forcedRefresh)
        
        return response.event
    }
}
