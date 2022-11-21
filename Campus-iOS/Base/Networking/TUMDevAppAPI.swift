//
//  TUMDevAppAPI.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.05.22.
//

import Foundation
import Alamofire
import CoreLocation
import CoreData

enum TUMDevAppAPI: URLRequestConvertible {
    case room(roomNr: Int)
    case rooms
    
    static let baseURL = "https://www.devapp.it.tum.de"
    
    static let decoder = JSONDecoder()
    
    var path: String {
        switch self {
        case .room, .rooms:             return "iris/ris_api.php"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .get
        }
    }
    
    static var requiresAuth: [String] = []
    
    func asURLRequest() throws -> URLRequest {
        let url = try TUMDevAppAPI.baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        
        switch self {
        case .room(let roomNr):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["format": "json", "raum": roomNr])
        case .rooms:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["format": "json"])
        }
        
        return urlRequest
    }
    
    // Maximum size of cache: 500kB, Maximum cache entries: 1000, Lifetime: 10min
    static let cache = Cache<String, Decodable>(totalCostLimit: 500_000, countLimit: 1_000, entryLifetime: 10 * 60)
    
    static func fetchStudyRooms(forcedRefresh: Bool) async throws -> StudyRoomApiRespose {

        let fullRequestURL = baseURL + self.rooms.path
        
        if !forcedRefresh, let rawStudyRoomsResponse = cache.value(forKey: baseURL + self.rooms.path), let studyRoomsResponse = rawStudyRoomsResponse as? StudyRoomApiRespose {
            print("Study rooms data from cache")
            return studyRoomsResponse
        } else {
            print("Study rooms data from server")
            // Fetch new data and store in cache.
            var studyRoomsData: Data
            do {
                studyRoomsData = try await AF.request(self.rooms).serializingData().value
            } catch {
                print(error)
                throw NetworkingError.deviceIsOffline
            }
            
            var studyRoomsResponse = StudyRoomApiRespose()
            do {
                studyRoomsResponse = try JSONDecoder().decode(StudyRoomApiRespose.self, from: studyRoomsData)
            } catch {
                print(error)
                throw error
            }
            
            // Write value to cache
            cache.setValue(studyRoomsResponse, forKey: fullRequestURL)
            
            return studyRoomsResponse
        }
    }
    
    static func delete<T: NSManagedObject & Decodable>(for type: T.Type, with context: NSManagedObjectContext) {
        
        do {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: T.self))
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeObjectIDs
            let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
            // Necessary to reflect the change of deletion inside the context.
            let changes: [AnyHashable: Any] = [
                NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] as Any
            ]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
        } catch {
            print(CoreDataError.deletingError("All entries of the Entity \(String(describing: T.self)) could not be deleted due to: \(error)"))
        }
    }
    
    static func fetchStudyRoomsCoreData(context: NSManagedObjectContext) async throws {
        delete(for: StudyRoomGroupCoreData.self, with: context)
        delete(for: StudyRoomCoreData.self, with: context)
        
        
        Self.decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
        
        // Fetch new data and store in cache.
        var studyRoomsData: Data
        do {
            studyRoomsData = try await AF.request(self.rooms).serializingData().value
        } catch {
            print(error)
            throw NetworkingError.deviceIsOffline
        }
        
        // Delete all entries
        // https://www.avanderlee.com/swift/nsbatchdeleterequest-core-data/
        
        
        
        do {
            let _: StudyRoomApiResponseCoreData = try decoder.decode(StudyRoomApiResponseCoreData.self, from: studyRoomsData)
        } catch {
            print(error)
            throw error
        }
        
        do {
            try context.save()
            print("Context saved for study rooms and groups")
            let defaults = UserDefaults.standard
            defaults.set(Date(), forKey: "\(String(describing: StudyRoomApiResponseCoreData.self))CoreDataStoringDate")
        } catch {
            throw CoreDataError.savingError("Context saving failed")
        }
    }
}
