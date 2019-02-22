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
import XMLParsing

protocol Entity: Decodable, NSFetchRequestResult { }


class Importer<EntityType: Entity, EntityContainer: Decodable, DecoderType: DecoderProtocol>: ImporterProtocol {
    var context: NSManagedObjectContext
    var endpoint: URLRequestConvertible
    var dateDecodingStrategy: DecoderType.DateDecodingStrategy?
    lazy var sessionManager: SessionManager = {
        let manager = SessionManager()
        manager.adapter = AuthenticationHandler(delegate: nil)
        manager.retrier = AuthenticationHandler(delegate: nil)
        return manager
    }()
    
    required init(context: NSManagedObjectContext, endpoint: URLRequestConvertible) {
        self.context = context
        self.endpoint = endpoint
    }
    
    required init(context: NSManagedObjectContext, endpoint: URLRequestConvertible, dateDecodingStrategy: DecoderType.DateDecodingStrategy) {
        self.context = context
        self.endpoint = endpoint
        self.dateDecodingStrategy = dateDecodingStrategy
    }
}


protocol ImporterProtocol: class {
    associatedtype DecoderType: DecoderProtocol
    associatedtype EntityType: Entity
    associatedtype EntityContainer: Decodable
    var context: NSManagedObjectContext { get }
    var sessionManager: SessionManager { get }
    var endpoint: URLRequestConvertible { get }
    var dateDecodingStrategy: DecoderType.DateDecodingStrategy? { get set }
    func performFetch()
    init(context: NSManagedObjectContext, endpoint: URLRequestConvertible)
    init(context: NSManagedObjectContext, endpoint: URLRequestConvertible, dateDecodingStrategy:  DecoderType.DateDecodingStrategy)
}

extension ImporterProtocol {
    func performFetch() {
        sessionManager.request(endpoint).responseData { [weak self] response in
            guard let self = self else { return }
            guard let data = response.data else { return }
            let decoder = DecoderType.instantiate()
            decoder.userInfo[.context] = self.context
            if let strategy = self.dateDecodingStrategy {
                decoder.dateDecodingStrategy = strategy
            }
            let entities = try! decoder.decode(EntityContainer.self, from: data)
            print(entities)
            try! self.context.save()
        }
    }
    var dateDecodingStrategy: DecoderType.DateDecodingStrategy? { return nil }
}

protocol DecoderProtocol: class {
    associatedtype DateDecodingStrategy: DecodingStrategyProtocol
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
    var userInfo: [CodingUserInfoKey : Any] { get set }
    var dateDecodingStrategy: DateDecodingStrategy { get set }
    static func instantiate() -> Self
}

protocol DecodingStrategyProtocol {
    
}

extension JSONDecoder.DateDecodingStrategy: DecodingStrategyProtocol { }

extension XMLDecoder.DateDecodingStrategy: DecodingStrategyProtocol { }

extension JSONDecoder: DecoderProtocol {
    static func instantiate() -> Self {
        //  infers the type of self from the calling context:
        func helper<T>() -> T {
            let decoder = JSONDecoder()
            return decoder as! T
        }
        return helper()
    }
}

extension XMLDecoder: DecoderProtocol {
    static func instantiate() -> Self {
        // infers the type of self from the calling context
        func helper<T>() -> T {
            let decoder = XMLDecoder()
            return decoder as! T
        }
        return helper()
    }
}
