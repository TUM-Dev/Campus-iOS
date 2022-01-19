//
//  GradesService.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation
import Alamofire
import XMLCoder

protocol LecturesServiceProtocol {
    func fetch(token: String, forcedRefresh: Bool) async throws -> [Lecture]
}

struct LecturesService: LecturesServiceProtocol {
    func fetch(token: String, forcedRefresh: Bool = false) async throws -> [Lecture] {
        let response: LectureComponents.RowSet =
        try await
            CampusOnlineAPI
                .makeRequest(
                    endpoint: Constants.API.CampusOnline.personalLectures,
                    token: token,
                    forcedRefresh: forcedRefresh
                )
        
        return response.row
    }
}
