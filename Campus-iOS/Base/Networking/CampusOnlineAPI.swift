//
//  CampusOnlineAPI.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 22.12.21.
//

import Foundation
import Alamofire
import XMLCoder
import CoreData

struct CampusOnlineAPI: NetworkingAPI {
    let persistenceController = PersistenceController.shared
    
    static let decoder: XMLDecoder = {
        let decoder = XMLDecoder()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }()
    
    // Maximum size of cache: 500kB, Maximum cache entries: 1000, Lifetime: 10min
    static let cache = Cache<String, Decodable>(totalCostLimit: 500_000, countLimit: 1_000, entryLifetime: 10 * 60)
    
    static func makeRequest<T: Decodable>(endpoint: APIConstants, token: String? = nil, forcedRefresh: Bool = false) async throws -> T {
        // Check cache first
        if !forcedRefresh,
           let data = cache.value(forKey: endpoint.fullRequestURL),
           let typedData = data as? T {
            return typedData
        // Otherwise make the request
        } else {
            var data: Data
            do {
                data = try await endpoint.asRequest(token: token).serializingData().value
            } catch {
                print(error)
                throw NetworkingError.deviceIsOffline
            }
            
            // Check this first cause otherwise no error is thrown by the XMLDecoder
            if let error = try? Self.decoder.decode(TUMOnlineAPIError.self, from: data) {
                print(error)
                throw error
            }
            
            do {
                let decodedData = try Self.decoder.decode(T.self, from: data)
                
                // Write value to cache
                cache.setValue(decodedData, forKey: endpoint.fullRequestURL, cost: data.count)
                
                return decodedData
            } catch {
                print(error)
                throw TUMOnlineAPIError.unkown(error.localizedDescription)
            }
        }
    }
    
    func loadCoreData<T: NSManagedObject & Decodable>(for type: RowSet<T>.Type, into context: NSManagedObjectContext, from endpoint: APIConstants, with token: String? = nil, forcedReload: Bool = false) async throws {
        
        // TODO: implement forcedRefresh: If false: Check if data of type T was recently downloaded updated, if so nothing to fetch/update; If true: delete all entries of the specified Entity (e.g. Grade) and fetch the grade and store them in CoreData.
        
        // Store the context in the user info of the decoder to be available when intializing Grade()-insances
        
        
        // Delete all entities
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Grade")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        
//        do {
//            try persistenceController.container.persistentStoreCoordinator.execute(deleteRequest, with: context)
//        } catch {
//            throw CoreDataError.deletingError("All entries of the Entity \(String(describing: T.self)) could not be deleted due to: \(error)")
//        }
        
        // Fetch data from server
        var data: Data
        do {
            data = try await endpoint.asRequest(token: token).serializingData().value
        } catch {
            throw NetworkingError.deviceIsOffline
        }
        
        // Check this first cause otherwise no error is thrown by the XMLDecoder
        if let error = try? Self.decoder.decode(TUMOnlineAPIError.self, from: data) {
            throw error
        }
        
        // Decode fetched data to the specified type
        do {
            Self.decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
            let newGradeSet = try Self.decoder.decode(GradeSet.self, from: data)
            let newGrades = newGradeSet.row
            
            for grade in newGrades {
                print(grade.title)
            }
            try context.save()
            
        } catch {
            throw TUMOnlineAPIError.unkown(error.localizedDescription)
        }
        
//        do {
//            try context.save()
//            print("Context saved for type \(type) and T \(T.self)")
//            let defaults = UserDefaults.standard
//            defaults.set(Date(), forKey: "\(String(describing: T.self))CoreDataStoringDate")
//        } catch {
//            throw CoreDataError.savingError("Context saving failed")
//        }
    }
    
    enum CoreDataError: Error {
        case savingError(String)
        case loadingError(String)
        case deletingError(String)
    }
    
//    enum Error: APIError {
//        case noPermission
//        case tokenNotConfirmed
//        case invalidToken
//        case unknown(String)
//
//        enum CodingKeys: String, CodingKey {
//            case message = "message"
//        }
//
//        init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//            let error = try container.decode(String.self, forKey: .message)
//
//            switch error {
//            case let str where str.contains("Keine Rechte für Funktion"):
//                self = .noPermission
//            case "Token ist nicht bestätigt!":
//                self = .tokenNotConfirmed
//            case "Token ist ungültig!":
//                self = .invalidToken
//            default:
//                self = .unknown(error)
//            }
//        }
//
//        public var errorDescription: String? {
//            switch self {
//            case .noPermission:
//                return "No Permission".localized
//            case .tokenNotConfirmed:
//                return "Token not confirmed".localized
//            case .invalidToken:
//                return "Token invalid".localized
//            case let .unknown(message):
//                return "Unknown error".localized + ": \(message)"
//
//            }
//        }
//
//        public var recoverySuggestion: String? {
//            switch self {
//            case .noPermission:
//                return "Make sure to enable the right permissions for your token."
//            case .tokenNotConfirmed:
//                return "Go to TUMonline and confirm your token."
//            case .invalidToken:
//                return "Try creating a new token."
//            default:
//                return nil
//            }
//        }
//    }
}
