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

typealias GradesSemesterDegrees = [(String, [(String, [Grade])])]

struct GradesService: ServiceTokenProtocol, GradesServiceProtocol {
    func fetch(token: String, forcedRefresh: Bool = false) async throws -> [Grade] {
        let response: TUMOnlineAPI.Response<Grade> = try await MainAPI.makeRequest(endpoint: TUMOnlineAPI.personalGrades, token: token, forcedRefresh: forcedRefresh)
        
        return response.row
            .sorted { gradeA, gradeB in
            return gradeA.date > gradeB.date
        }
    }
}
