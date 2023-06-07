//
//  EventsService.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 07.06.23.
//

import Foundation

protocol EventServiceProtocol {
    func talks() async throws -> [TUMEvent]
}

struct EventsService: EventServiceProtocol {
    func talks() async throws -> [TUMEvent] {
        return try await MainAPI.makeRequest(endpoint: EventsAPI.talks)
    }
}
