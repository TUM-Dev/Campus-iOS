//
//  GradesService.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation
import Alamofire
import CoreData

protocol GradesServiceProtocol {
    func fetch(token: String, forcedRefresh: Bool) async throws -> [Grade]
    func fetchCoreData(into context: NSManagedObjectContext, token: String, forcedRefresh: Bool) async throws
}

struct GradesService: GradesServiceProtocol {    
    func fetch(token: String, forcedRefresh: Bool = false) async throws -> [Grade] {
        let response: GradeSet =
        try await
            CampusOnlineAPI
                .makeRequest(
                    endpoint: Constants.API.CampusOnline.personalGrades,
                    token: token,
                    forcedRefresh: forcedRefresh
                )

        return response.row
    }
    
    func fetchCoreData(into context: NSManagedObjectContext, token: String, forcedRefresh: Bool = false) async throws {
        try await CampusOnlineAPI().loadCoreData(for: RowSet<Grade>.self, into: context, from: Constants.API.CampusOnline.personalGrades, with: token)
    }
}
