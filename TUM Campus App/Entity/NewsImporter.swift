//
//  NewsImporter.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 14.6.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit.UIApplication
import Alamofire
import CoreData
import FirebaseCrashlytics

final class NewsImporter {
    typealias EntityType = NewsSource
    typealias EntityContainer = [NewsSource]
    typealias DecoderType = JSONDecoder
    typealias ErrorHandler = (Error) -> Void
    typealias SuccessHandler = () -> Void

    static let sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \NewsSource.title, ascending: true)]

    private static let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    private static let coreDataStack: NSPersistentContainer = AppDelegate.persistentContainer

    private let sessionManager: Session = Session.defaultSession

    let endpoint: URLRequestConvertible = TUMCabeAPI.newsSources
    let dateDecodingStrategy: DecoderType.DateDecodingStrategy? = .formatted(.yyyyMMddhhmmss)
    let fetchedResultsController: NSFetchedResultsController<EntityType> = {
        let fetchRequest: NSFetchRequest<EntityType> = EntityType.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.viewContext, sectionNameKeyPath: EntityType.sectionNameKeyPath?.stringValue, cacheName: nil)

        return fetchedResultsController
    }()
    let context: NSManagedObjectContext = {
        let context = coreDataStack.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }()

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
                let group = DispatchGroup()
                do {
                    let sources = try decoder.decode([NewsSource].self, from: data)
                    sources.forEach {
                        group.enter()
                        let endpoint = TUMCabeAPI.news(source: $0.id.description)
                        self.sessionManager.request(endpoint)
                            .validate(statusCode: 200..<300)
                            .validate(contentType: DecoderType.contentType)
                            .responseData { response in
                                defer { group.leave() }
                                guard let data = response.data else { return }
                                let decoder = DecoderType.instantiate()
                                decoder.userInfo[.context] = self.context
                                if let strategy = self.dateDecodingStrategy {
                                    decoder.dateDecodingStrategy = strategy
                                }
                                _ = try? decoder.decode([News].self, from: data)
                        }
                    }
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
                group.notify(queue: .main) {
                    try? self.context.save()
                    successHandler?()
                }
        }
    }

}
