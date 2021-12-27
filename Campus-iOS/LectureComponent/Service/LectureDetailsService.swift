//
//  LectureDetailsService.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 25.12.21.
//

import Foundation
import Alamofire
import XMLCoder

protocol LectureDetailsServiceProtocol {
    func fetch(token: String, lvNr: UInt64, forcedRefresh: Bool) async throws -> LectureDetails
}

struct LectureDetailsService: LectureDetailsServiceProtocol {
    func fetch(token: String, lvNr: UInt64, forcedRefresh: Bool = false) async throws -> LectureDetails {
        let response: LectureDetailsComponents.RowSet =
            try await
                CampusOnlineAPI
                    .makeRequest(
                        endpoint: Constants.API.CampusOnline.lectureDetails(lvNr: String(lvNr)),
                        token: token,
                        forcedRefresh: forcedRefresh
                    )
        
        guard let data = response.row.first else {
            throw NetworkingError.resourceNotFound
        }
        
        return data
    }
}
