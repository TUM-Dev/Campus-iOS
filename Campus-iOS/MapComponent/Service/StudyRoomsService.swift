//
//  StudyRoomsService.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.06.22.
//

import Foundation
import CoreData

protocol StudyRoomsServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> StudyRoomApiRespose
    
    func fetch(context: NSManagedObjectContext) async throws
}

struct StudyRoomsService: StudyRoomsServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> StudyRoomApiRespose {
        return try await TUMDevAppAPI.fetchStudyRooms(forcedRefresh: forcedRefresh)
    }
    
    func fetch(context: NSManagedObjectContext) async throws {
        try await TUMDevAppAPI.fetchStudyRoomsCoreData(context: context)
    }
}
