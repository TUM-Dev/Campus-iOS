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

class Importer<EntityType: Entity, EntityContainer: Decodable, DecoderType: DecoderProtocol>: ImporterProtocol {
    let endpoint: URLRequestConvertible
    let sortDescriptors: [NSSortDescriptor]
    var predicate: NSPredicate?
    var dateDecodingStrategy: DecoderType.DateDecodingStrategy?
    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    lazy var sessionManager: SessionManager = SessionManager.defaultSessionManager
    
    lazy var fetchedResultsController: NSFetchedResultsController<EntityType> = {
        let fetchRequest: NSFetchRequest<EntityType> = EntityType.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.viewContext, sectionNameKeyPath: EntityType.sectionNameKeyPath?.stringValue, cacheName: nil)
        fetchedResultsController.delegate = fetchedResultsControllerDelegate
        
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
    var sessionManager: SessionManager { get }
    var endpoint: URLRequestConvertible { get }
    var sortDescriptors: [NSSortDescriptor] { get }
    var predicate: NSPredicate? { get }
    var dateDecodingStrategy: DecoderType.DateDecodingStrategy? { get set }
    
    init(endpoint: URLRequestConvertible, sortDescriptor: NSSortDescriptor..., predicate: NSPredicate?, dateDecodingStrategy:  DecoderType.DateDecodingStrategy?)
}

typealias ErrorHandler = (Error) -> Void

extension ImporterProtocol {
    func performFetch(error: ErrorHandler? = nil) {
        sessionManager.request(endpoint)
            .validate(statusCode: 200..<300)
            .validate(contentType: DecoderType.contentType)
            .responseData { response in
//                guard let self = self else { return }
                if let responseError = response.error {
                    error?(responseError)
                    return
                }
                guard let data = response.data else {
                    error?(ImporterError.invalidData)
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
                } catch let apiError where error is APIError {
                    error?(apiError)
                } catch let error {
                    fatalError(error.localizedDescription)
                }
        }
    }
    var dateDecodingStrategy: DecoderType.DateDecodingStrategy? { return nil }
    var appDelegate: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    var coreDataStack: NSPersistentContainer { return appDelegate.persistentContainer }
}
