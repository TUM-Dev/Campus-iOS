//
//  NetworkingServiceProtocl.swift
//  Campus-iOS
//
//  Created by David Lin on 04.11.22.
//

import Foundation
import CoreData

protocol NetworkingServiceProtocol {
    func fetch(into context: NSManagedObjectContext, with token: String) async throws
    func fetchIsNeeded<T: Decodable & NSManagedObject>(for type: T.Type) -> Bool
}
