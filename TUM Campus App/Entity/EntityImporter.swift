//
//  EntityImporter.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/20/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

protocol Entity: Decodable, NSFetchRequestResult, NSObject {
    static func fetchRequest() -> NSFetchRequest<Self>
    static var sectionNameKeyPath: KeyPath<Self, String?>? { get }
}

extension Entity {
    static var sectionNameKeyPath: KeyPath<Self, String?>? { nil }
}

enum ImporterError: Error {
    case invalidData
}

final class Importer<EntityType: Entity, EntityContainer: Decodable, DecoderType: DecoderProtocol>: ImporterProtocol {
    let endpoint: URLRequestConvertible
    let sortDescriptors: [NSSortDescriptor]
    var predicate: NSPredicate?
    var dateDecodingStrategy: DecoderType.DateDecodingStrategy?

    lazy var sessionManager: Session = Session.defaultSession
    
    lazy var fetchedResultsController: NSFetchedResultsController<EntityType> = {
        let fetchRequest: NSFetchRequest<EntityType> = EntityType.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.viewContext, sectionNameKeyPath: EntityType.sectionNameKeyPath?.stringValue, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    lazy var context: NSManagedObjectContext = {
        let context = coreDataStack.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }()
    
    required init(endpoint: URLRequestConvertible, sortDescriptor: NSSortDescriptor..., predicate: NSPredicate? = nil, dateDecodingStrategy:  DecoderType.DateDecodingStrategy? = nil) {
        self.endpoint = endpoint
        self.predicate = predicate
        self.sortDescriptors = sortDescriptor
        self.dateDecodingStrategy = dateDecodingStrategy
    }
}


protocol ImporterProtocol {
    associatedtype DecoderType: DecoderProtocol
    associatedtype EntityType: Entity
    associatedtype EntityContainer: Decodable

    var context: NSManagedObjectContext { get }
    var fetchedResultsController: NSFetchedResultsController<EntityType> { get }
    var sessionManager: Session { get }
    var endpoint: URLRequestConvertible { get }
    var sortDescriptors: [NSSortDescriptor] { get }
    var predicate: NSPredicate? { get }
    var dateDecodingStrategy: DecoderType.DateDecodingStrategy? { get set }
}

typealias ErrorHandler = (Error) -> Void
typealias SuccessHandler = () -> Void

extension ImporterProtocol {
    func performFetch(success successHandler: SuccessHandler? = nil, error errorHandler: ErrorHandler? = nil) {
        sessionManager.request(endpoint)
            .validate(statusCode: 200..<300)
            .validate(contentType: DecoderType.contentType)
            .responseData { response in
                if let responseError = response.error {
                    errorHandler?(responseError)
                    return
                }
                guard let data = response.data else {
                    errorHandler?(ImporterError.invalidData)
                    return
                }
                let decoder = DecoderType.instantiate()
                decoder.userInfo[.context] = self.context
                if let strategy = self.dateDecodingStrategy {
                    decoder.dateDecodingStrategy = strategy
                }
                do {
                    _ = try decoder.decode(EntityContainer.self, from: data)
                    try self.context.save()
                } catch let apiError as APIError {
                    errorHandler?(apiError)
                    return
                } catch let decodingError as DecodingError {
                    errorHandler?(decodingError)
                    return
                } catch let error {
                    fatalError(error.localizedDescription)
                }
                successHandler?()
        }
    }
    var dateDecodingStrategy: DecoderType.DateDecodingStrategy? { return nil }
    var appDelegate: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    var coreDataStack: NSPersistentContainer { return appDelegate.persistentContainer }
}
