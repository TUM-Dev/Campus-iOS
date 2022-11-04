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
    
    /// Fetches the data of for `type` into the given `context` (i.e. CoreData).
    ///
    /// Perfoming a fetch of the `type` `RowSet<Grade>`. This will fetch all grades and deltes the old entries of the Entity `Grades` in the context (i.e. CoreData). Afterwards it will decode the fetched data into `RowSet<Grades>` and save them into the context.
    /// ```
    /// try await CampusOnlineAPI.fetch(for: RowSet<Grade>.self, into: context, from: Constants.API.CampusOnline.personalGrades, with: token)
    /// ```
    ///
    /// > Hint: CoreData saves new objects after they are initilized and `try context.save()` was executed.
    /// > Since at decoding each grade will be initialized as new `Grade` instance and at initialization of `Grade` the context was given CoreData knows about the new `Grade` instances and stores them after executing `save()` from the given `context`.
    ///
    /// - Parameters:
    ///     - type: The type in which the XML respond of the fetch will be decoded. Since XML parsing has an additional `row` variable it is necessary to use the generic `RowSet<T: NSManagedObject & Decodable>` struct which is defined in `RowSet.swift`.
    ///     - context: The `NSManagedObjectContext` used to save the new `Grade` instaces created by the Decoder.
    ///     - endpoint: The URL endpoint from which we will fetch the data.
    ///     - token: The users' TUMOnline token to autheticate for the fetch.
    ///
    static func fetch<T: NSManagedObject & Decodable>(for type: RowSet<T>.Type, into context: NSManagedObjectContext, from endpoint: APIConstants, with token: String? = nil) async throws {
        
        Self.decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
        
        // Store the context in the user info of the decoder to be available when intializing Grade()-insances
        Self.decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
        
        do {
            // https://www.avanderlee.com/swift/nsbatchdeleterequest-core-data/
            // Delete all entities
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
            let _ = try Self.decoder.decode(type.self, from: data)
        } catch {
            throw TUMOnlineAPIError.unkown(error.localizedDescription)
        }
        
        // Saving the data into CoreData
        do {
            try context.save()
            print("Context saved for type \(type)")
            let defaults = UserDefaults.standard
            defaults.set(Date(), forKey: "\(String(describing: T.self))CoreDataStoringDate")
        } catch {
            throw CoreDataError.savingError("Context saving failed")
        }
    }
    
    /// A Boolean value indicating whether a new fetch of the data from the server is neccessery.
    ///
    /// Since the fetches should not occur too often a check if a fetch is needed. A fetch is needed if the given threshold (in seconds) is exceeded since the last fetch.
    /// ```
    /// CampusOnlineAPI.fetchIsNeeded(for: Grade.self, threshold: 30 * 60)
    /// ```
    /// Here after `30` minutes a new fetched will be declared as necessary.
    ///
    /// - Parameters:
    ///     - type: The type of date which should be checked if fetching is necessary (e.g. `Grades`)
    ///     - threshold: The time invertal in seconds after the last fetch another fetch should be declared as necessary.
    ///
    /// - Returns: A Boolen value if a fetch is needed for a specific `type` after exceeding a specific `threshold`.
    static func fetchIsNeeded<T: Decodable & NSManagedObject>(for type: T.Type, threshold: TimeInterval) -> Bool {
        let defaults = UserDefaults.standard
        guard let lastFetchDate = defaults.object(forKey: "\(String(describing: type))CoreDataStoringDate") as? Date else {
            return true
        }
        
        let fetchThresholdDate = Date().addingTimeInterval(-threshold)
        print(lastFetchDate <= fetchThresholdDate)
        print(lastFetchDate)
        print(fetchThresholdDate)
        
        return lastFetchDate <= fetchThresholdDate
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
