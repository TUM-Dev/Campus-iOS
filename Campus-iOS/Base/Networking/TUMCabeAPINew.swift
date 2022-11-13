//
//  TUMCabeAPI-new.swift
//  Campus-iOS
//
//  Created by David Lin on 07.11.22.
//

import Foundation
import CoreData

struct TUMCabeAPINew: TUMCabeAPIProtocol {
    static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.yyyyMMddhhmmss)
        
        return decoder
    }()
    
    static func fetch<T: NSManagedObject & Decodable>(for type: [T].Type , into context: NSManagedObjectContext, from endpoint: TUMCabeProtocol) async throws {
        
        // Store the context in the user info of the decoder to be available when intializing Grade()-insances
        Self.decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
        
        // Fetch data from server
        var data: Data
        do {
            data = try await endpoint.asRequest().serializingData().value
        } catch {
            throw NetworkingError.deviceIsOffline
        }
        
        // TODO: Refactoring for deleting NewsItems within a NewsItemSource. Maybe a different approach is needed like comparison or manually deletion.
        // Delete all entries
        // https://www.avanderlee.com/swift/nsbatchdeleterequest-core-data/
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
        
        // Check this first cause otherwise no error is thrown by the XMLDecoder
        if let error = try? Self.decoder.decode(TUMOnlineAPIError.self, from: data) {
            throw error
        }
        
        // Decode fetched data to the specified type
        do {
            let _ = try Self.decoder.decode(type.self, from: data)
            
        } catch {
            throw TUMOnlineAPIError.unkown(String(describing: error))
        }
        
        // Saving the data into CoreData
        do {
            try context.save()
            print("Context saved for type \(type)")
            let defaults = UserDefaults.standard
            defaults.set(Date(), forKey: "\(String(describing: T.self))CoreDataStoringDate")
        } catch {
            throw CoreDataError.savingError("Context saving failed: \(String(describing: error))")
        }
    }
    
    static func fetchIsNeeded<T: NSManagedObject & Decodable>(for type: T.Type, threshold: TimeInterval) -> Bool {
        return true
    }
    
    static func fetchNewsItems(into context: NSManagedObjectContext, from endpoint: TUMCabeProtocol, with source: NewsItemSource) async throws -> [NewsItem] {
        
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        // Store the context in the user info of the decoder to be available when intializing Grade()-insances
        Self.decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
        
        Self.decoder.userInfo[CodingUserInfoKey.newsItemSource] = source
        
        // Delete all entries
        // https://www.avanderlee.com/swift/nsbatchdeleterequest-core-data/
        do {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: NewsItem.self))
            fetchRequest.predicate = NSPredicate(format: "newsItemSource = %@", source)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeObjectIDs
            let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
            // Necessary to reflect the change of deletion inside the context.
            let changes: [AnyHashable: Any] = [
                NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] as Any
            ]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
        } catch {
            print(CoreDataError.deletingError("All entries of the Entity \(String(describing: NewsItem.self)) could not be deleted due to: \(error)"))
        }
        
        // Fetch data from server
        var data: Data
        do {
            data = try await endpoint.asRequest().serializingData().value
        } catch {
            throw NetworkingError.deviceIsOffline
        }
        
        // Check this first cause otherwise no error is thrown by the XMLDecoder
        if let error = try? Self.decoder.decode(TUMOnlineAPIError.self, from: data) {
            throw error
        }
        
        // Decode fetched data to the specified type
        var decodedData: [NewsItem]
        do {
            decodedData = try Self.decoder.decode([NewsItem].self, from: data)
//            for newsItem in decodedData {
//                newsItem.newsItemSource = source
//            }
        } catch {
            throw TUMOnlineAPIError.unkown(String(describing: error))
        }
        
        // Saving the data into CoreData
        do {
            try context.save()
            print("Context saved for type \([NewsItem].self)")
            let defaults = UserDefaults.standard
            defaults.set(Date(), forKey: "\(String(describing: NewsItem.self))CoreDataStoringDate")
        } catch {
            throw CoreDataError.savingError("Context saving failed: \(String(describing: error))")
        }
        
        return decodedData
    }
}
