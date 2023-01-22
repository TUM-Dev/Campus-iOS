//
//  StudyRoomsService.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.06.22.
//

import Foundation

protocol StudyRoomsServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> StudyRoomApiRespose
}

struct StudyRoomsService: StudyRoomsServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> StudyRoomApiRespose {
        return try await TUMDevAppAPI.fetchStudyRooms(forcedRefresh: forcedRefresh)
    }
    
    func fetchMap(room: String, forcedRefresh: Bool) async throws -> [RoomImageMapping] {
        let response: [RoomImageMapping] = try await MainAPI.makeRequest(endpoint: TUMCabeAPI2.roomMaps(room: room))
        
        return response
    }
}
