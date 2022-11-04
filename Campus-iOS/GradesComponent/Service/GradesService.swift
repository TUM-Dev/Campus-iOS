//
//  GradesService.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation
import Alamofire
import CoreData

struct GradesService: NetworkingServiceProtocol {
    /// `Deprecated` after CoreData integration
    func fetch(token: String, forcedRefresh: Bool) async throws -> [Grade] {
        let response: GradeSet =
        try await
            CampusOnlineAPI
                .makeRequest(
                    endpoint: Constants.API.CampusOnline.personalGrades,
                    token: token
                )

        return response.row
    }
    
    // New function for CoreData integration
    
    func fetch(into context: NSManagedObjectContext, with token: String) async throws {
        try await CampusOnlineAPI.fetch(for: RowSet<Grade>.self, into: context, from: Constants.API.CampusOnline.personalGrades, with: token)
    }
    
    func fetchIsNeeded<T: Decodable & NSManagedObject>(for type: T.Type) -> Bool {
        return CampusOnlineAPI.fetchIsNeeded(for: type, threshold: 30 * 60)
    }
}
