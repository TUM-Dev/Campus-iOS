//
//  GradesService.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation
import Alamofire

struct GradesService: ServiceTokenProtocol {
    func fetch(token: String, forcedRefresh: Bool = false) async throws -> [Grade] {
        let response: TUMOnlineAPI2.Response<Grade> = try await MainAPI.makeRequest(endpoint: TUMOnlineAPI2.personalGrades, token: token, forcedRefresh: forcedRefresh)
        
        return response.row
    }
}
