//
//  NewsImporter.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 14.6.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import Foundation
import Alamofire
import CoreData
import FirebaseCrashlytics

final class NewsImporter: ImporterProtocol {
    typealias EntityType = NewsSource
    typealias EntityContainer = [NewsSource]
    typealias DecoderType = JSONDecoder

    let endpoint: URLRequestConvertible = TUMCabeAPI.newsSources
    let sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \NewsSource.title, ascending: true)]
    var dateDecodingStrategy: DecoderType.DateDecodingStrategy? = .formatted(.yyyyMMddhhmmss)

    lazy var sessionManager: Session = Session.defaultSession

    lazy var fetchedResultsController: NSFetchedResultsController<EntityType> = {
        let fetchRequest: NSFetchRequest<EntityType> = EntityType.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.viewContext, sectionNameKeyPath: EntityType.sectionNameKeyPath?.stringValue, cacheName: nil)

        return fetchedResultsController
    }()

    lazy var context: NSManagedObjectContext = {
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
//                    try? self.context.save()
                    let sources = try decoder.decode([NewsSource].self, from: data)
                    sources.forEach {
                        group.enter()
                        let endpoint = TUMCabeAPI.news(source: $0.id.description)
                        self.sessionManager.request(endpoint)
                            .validate(statusCode: 200..<300)
                            .validate(contentType: DecoderType.contentType)
                            .responseData { response in
                                defer { group.leave() }
                                if let responseError = response.error {
//                                    errorHandler?(responseError)
                                    return
                                }
                                guard let data = response.data else {
//                                    errorHandler?(ImporterError.invalidData)
                                    return
                                }
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
