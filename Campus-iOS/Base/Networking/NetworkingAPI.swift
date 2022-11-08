//
//  NetworkingAPI.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 22.12.21.
//

import Foundation
import Combine
import CoreData

protocol NetworkingAPI {
    // Renaming to `DecoderType` as we otherwise have a conflict between the `Decoder` associatedtype of `Decodable` and the `Decoder` associatedtype of `NetworkingAPI`
    associatedtype DecoderType: TopLevelDecoder
    static var decoder: DecoderType { get }
    
    static func fetchIsNeeded<T: NSManagedObject & Decodable>(for type: T.Type, threshold: TimeInterval) -> Bool
}

protocol CampusOnlineAPIProtocol: NetworkingAPI {
    static func fetch<T: NSManagedObject & Decodable>(for type: RowSet<T>.Type, into context: NSManagedObjectContext, from endpoint: CampusOnlineProtocol, with token: String?) async throws
    
    ///*DEPRECATED AFTER COREDATA INTEGRATION*
    static var cache: Cache<String, Decodable> { get }
    
    static func makeRequest<T: Decodable>(endpoint: CampusOnlineProtocol, token: String?, forcedRefresh: Bool) async throws -> T
}

protocol TUMCabeAPIProtocol: NetworkingAPI {
    static func fetch<T: NSManagedObject & Decodable>(for type: [T].Type, into context: NSManagedObjectContext, from endpoint: TUMCabeProtocol) async throws
}
