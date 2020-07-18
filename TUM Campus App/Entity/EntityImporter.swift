//
//  EntityImporter.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/20/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit.UIApplication
import CoreData
import Alamofire
import FirebaseCrashlytics

protocol Entity: NSManagedObject, Decodable {
    static func fetchRequest() -> NSFetchRequest<Self>
    static var sectionNameKeyPath: KeyPath<Self, String?>? { get }
}

extension Entity {
    static var sectionNameKeyPath: KeyPath<Self, String?>? { nil }
}

enum ImporterError: Error {
    case invalidData
}

final class Importer<EntityType: Entity, EntityContainer: Decodable, DecoderType: DecoderProtocol> {
    typealias ErrorHandler = (Error) -> Void
    typealias SuccessHandler = () -> Void

    let endpoint: URLRequestConvertible
    let dateDecodingStrategy: DecoderType.DateDecodingStrategy?
    let sortDescriptors: [NSSortDescriptor]
    let predicate: NSPredicate?

    private let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    private let sessionManager = Session.defaultSession

    private let coreDataStack: NSPersistentContainer = AppDelegate.persistentContainer

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
                    let fetchRequest: NSFetchRequest<EntityType> = EntityType.fetchRequest()
                    try self.context.fetch(fetchRequest).forEach { self.context.delete($0) }
                    _ = try decoder.decode(EntityContainer.self, from: data)
                    try self.context.save()
                } catch let apiError as APIError {
                    Crashlytics.crashlytics().record(error: apiError)
                    errorHandler?(apiError)
                    return
                } catch let decodingError as DecodingError {
                    Crashlytics.crashlytics().record(error: decodingError)
                    errorHandler?(decodingError)
                    return
                } catch let error {
                    Crashlytics.crashlytics().record(error: error)
                    fatalError(error.localizedDescription)
                }
                successHandler?()
        }
    }

}
