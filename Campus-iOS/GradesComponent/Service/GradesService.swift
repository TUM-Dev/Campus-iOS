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
        let value = AF.request(APIConstants.baseURL.appending("wbservicesbasic.noten?pToken=\(token)")).serializingData()
        
        let xmlDecoder = XMLDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        xmlDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        let grade = try await xmlDecoder.decode(RowSet.self, from: value.value)
        
        return grade.row
    }
}
