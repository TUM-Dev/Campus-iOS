//
//  LectureSearchService.swift
//  Campus-iOS
//
//  Created by David Lin on 20.01.23.
//

import Foundation

struct LectureSearchService {
    func fetch(for query: String, token: String, forcedRefresh: Bool) async throws -> [Lecture] {
        let response : TUMOnlineAPI.Response<Lecture> = try await MainAPI.makeRequest(endpoint: TUMOnlineAPI.lectureSearch(search: query), token: token, forcedRefresh: forcedRefresh)
        
        return response.row
    }
}
