//
//  GradesService.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation
import Alamofire
import XMLCoder

protocol GradesServiceProtocol {
    func fetch(token: String) async throws -> [Grade]
}

struct GradesService: GradesServiceProtocol {
    func fetch(token: String) async throws -> [Grade] {
        let response: GradeComponents.RowSet =
        try await
            CampusOnlineAPI
                .makeRequest(
                    endpoint: Constants.API.CampusOnline.personalGrades,
                    token: token
                )
        
        return response.row
    }
}
