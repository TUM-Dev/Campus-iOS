//
//  StudyRoomsService.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.06.22.
//

import Foundation
import CoreData

protocol StudyRoomsServiceProtocol {
//    func fetch(forcedRefresh: Bool) async throws -> StudyRoomApiRespose
    
    func fetch(context: NSManagedObjectContext) async throws
    
    func fetchIsNeeded<T: Decodable>(for type: T.Type) -> Bool
}

struct StudyRoomsService: StudyRoomsServiceProtocol {
//    func fetch(forcedRefresh: Bool) async throws -> StudyRoomApiRespose {
//        return try await TUMDevAppAPI.fetchStudyRooms(forcedRefresh: forcedRefresh)
//    }
    
    func fetch(context: NSManagedObjectContext) async throws {
        // Delete all entries
                // https://www.avanderlee.com/swift/nsbatchdeleterequest-core-data/
        DispatchQueue.main.async {
            TUMDevAppAPI.delete(for: StudyRoomCoreData.self, with: context)
            TUMDevAppAPI.delete(for: StudyRoomGroupCoreData.self, with: context)
        }
        
        
        try await TUMDevAppAPI.fetchStudyRoomsCoreData(context: context)
    }
    
    func fetchIsNeeded<T: Decodable>(for type: T.Type) -> Bool {
        return TUMDevAppAPI.fetchIsNeeded(for: type, threshold: 10)
    }
}
