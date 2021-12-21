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
        let request = AF.request(APIConstants.baseURL.appending(APIConstants.personalGrades), parameters: ["pToken": token]).serializingData()
        
        let xmlDecoder = XMLDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        xmlDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        let grade = try await xmlDecoder.decode(GradeComponents.RowSet.self, from: request.value)
        
        return grade.row
    }
}

extension APIConstants {
    static let personalGrades = "wbservicesbasic.noten"
}
