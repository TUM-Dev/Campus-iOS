//
//  EntityImporter.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.01.22.
//

import UIKit.UIApplication
//import CoreData
import Alamofire
import FirebaseCrashlytics

protocol Entity: Decodable {
    
}

enum ImporterError: Error {
    case invalidData
}

final class Importer<EntityType: Entity, EntityContainer: Decodable, DecoderType: DecoderProtocol> {
    typealias RequestHandler = (Result<EntityContainer, Error>) -> Void

    let endpoint: URLRequestConvertible
    let dateDecodingStrategy: DecoderType.DateDecodingStrategy?
    let predicate: NSPredicate?

    private let sessionManager = Session.defaultSession
    
    required init(endpoint: URLRequestConvertible, predicate: NSPredicate? = nil, dateDecodingStrategy:  DecoderType.DateDecodingStrategy? = nil) {
        self.endpoint = endpoint
        self.predicate = predicate
        self.dateDecodingStrategy = dateDecodingStrategy
    }

    func performFetch(handler: RequestHandler? = nil) {
        sessionManager.request(endpoint)
            .validate(statusCode: 200..<300)
            .validate(contentType: DecoderType.contentType)
            .responseData { response in
                if let responseError = response.error {
                    handler?(.failure(BackendError.AFError(message: responseError.localizedDescription)))
                    return
                }
                guard let data = response.data else {
                    handler?(.failure(ImporterError.invalidData))
                    return
                }
                
                let decoder = DecoderType.instantiate()
                if let strategy = self.dateDecodingStrategy {
                    decoder.dateDecodingStrategy = strategy
                }
                do {
                    let storage = try decoder.decode(EntityContainer.self, from: data)
                    handler?(.success(storage))
                } catch let apiError as APIError {
                    Crashlytics.crashlytics().record(error: apiError)
                    handler?(.failure(apiError))
                    return
                } catch let decodingError as DecodingError {
                    Crashlytics.crashlytics().record(error: decodingError)
                    handler?(.failure(decodingError))
                    return
                } catch let error {
                    Crashlytics.crashlytics().record(error: error)
                    handler?(.failure(error))
                }
        }
    }

}
