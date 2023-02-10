//
//  StudyRoomsService.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.06.22.
//

import Foundation

struct StudyRoomsService {
    func fetch(forcedRefresh: Bool) async throws -> StudyRoomApiRespose {
        let response: StudyRoomApiRespose = try await MainAPI.makeRequest(endpoint: TUMDevAppAPI.rooms, forcedRefresh: forcedRefresh)
        
        return response
    }
    
    func fetchMap(room: String, forcedRefresh: Bool) async throws -> [RoomImageMapping] {
        let response: [RoomImageMapping] = try await MainAPI.makeRequest(endpoint: TUMCabeAPI.roomMaps(room: room))
        
        return response
    }
}
