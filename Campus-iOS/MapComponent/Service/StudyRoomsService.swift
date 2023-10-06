//
//  StudyRoomsService.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.06.22.
//

import Foundation
import UIKit

protocol StudyRoomsServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> StudyRoomApiRespose
}

struct StudyRoomsService: StudyRoomsServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> StudyRoomApiRespose {
        let response: StudyRoomApiRespose = try await MainAPI.makeRequest(endpoint: TUMDevAppAPI.rooms, forcedRefresh: forcedRefresh)
        return response
    }
}
