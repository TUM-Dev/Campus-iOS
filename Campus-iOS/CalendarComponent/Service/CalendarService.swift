//
//  CalendarService.swift
//  Campus-iOS
//
//  Created by David Lin on 29.12.22.
//

import Foundation

protocol CalendarServiceProtocol {
    func fetch(token: String, forcedRefresh: Bool) async throws -> [CalendarEvent]
}

struct CalendarService: CalendarServiceProtocol {
    func fetch(token: String, forcedRefresh: Bool) async throws -> [CalendarEvent] {
        return try await TUMOnlineAPI.makeRequest(endpoint: .calendar, token: token, forcedRefresh: false)
    }
}
