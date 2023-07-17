//
//  AverageGradeService.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 08.05.23.
//

import Foundation

struct AverageGradesService: ServiceTokenProtocol {
    func fetch(token: String, forcedRefresh: Bool = false) async throws -> [AverageGrade] {
        let response: TUMOnlineAPI.AverageGradesResponse = try await MainAPI.makeRequest(endpoint: TUMOnlineAPI.averageGrades, token: token, forcedRefresh: forcedRefresh)
        
        return response.studium
    }
}
