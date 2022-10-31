//
//  GradesService.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation
import Alamofire

protocol GradesServiceProtocol {
    func fetch(token: String, forcedRefresh: Bool) async throws -> [Grade]
}

struct GradesService: GradesServiceProtocol {    
    func fetch(token: String, forcedRefresh: Bool = false) async throws -> [Grade] {
        let response: GradeComponents.RowSet =
        try await
            CampusOnlineAPI
                .makeRequest(
                    endpoint: Constants.API.CampusOnline.personalGrades,
                    token: token,
                    forcedRefresh: forcedRefresh
                )
        
        return response.row
    }
}
