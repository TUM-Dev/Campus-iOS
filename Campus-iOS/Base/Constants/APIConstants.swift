//
//  APIConstants.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation
import Alamofire

protocol APIConstants {
    static var baseURL: String { get }
    var relativePathURL: String { get }
    var fullPathURL: String { get }
    
    var parameters: [String: String] { get }
    var needsAuth: Bool { get }
    
    func asRequest(token: String?) -> DataRequest
}

extension Constants {
    enum API {
        enum CampusOnline: APIConstants {
            static let baseURL = "https://campus.tum.de/tumonline/"
            
            case personalLectures
            case personalGrades
            
            var relativePathURL: String {
                switch self {
                    case .personalLectures: return "wbservicesbasic.veranstaltungenEigene"
                    case .personalGrades: return "wbservicesbasic.noten"
                }
            }
            
            var fullPathURL: String {
                Self.baseURL + self.relativePathURL
            }
            
            var parameters: [String: String] {
                switch self {
                    case .personalLectures, .personalGrades: return [:]
                }
            }
            
            var needsAuth: Bool {
                switch self {
                    case .personalLectures, .personalGrades: return true
                }
            }
            
            func asRequest(token: String? = nil) -> DataRequest {
                if self.needsAuth {
                    return AF.request(self.fullPathURL, parameters: self.parameters.merging(["pToken": token ?? ""], uniquingKeysWith: { (current, _) in current }))
                } else {
                    return AF.request(self.fullPathURL, parameters: self.parameters)
                }
            }
        }
    }
}
