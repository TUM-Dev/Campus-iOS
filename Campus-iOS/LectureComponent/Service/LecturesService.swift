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
    func fetch(token: String) async throws -> [Lecture]
}

struct LecturesService: LecturesServiceProtocol {
    func fetch(token: String) async throws -> [Lecture] {
        let request = AF.request(APIConstants.baseURL.appending(APIConstants.personalLectures), parameters: ["pToken": token]).serializingData()
        let grade = try await XMLDecoder().decode(LectureComponents.RowSet.self, from: request.value)
        
        return grade.row
    }
}

extension APIConstants {
    static let personalLectures = "wbservicesbasic.veranstaltungenEigene"
}
