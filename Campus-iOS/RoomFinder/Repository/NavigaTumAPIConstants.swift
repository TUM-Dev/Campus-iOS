//
//  NavigaTumAPIConstants.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 01.01.23.
//

import Foundation
import Alamofire

extension Constants.API {
    enum NavigaTum: APIConstants {
        static let baseURL = "https://nav.tum.de/"
//        static let baseMapURL = "https://nav.tum.de/cdn/maps/roomfinder/"
        private static let responseCacherAF = ResponseCacher(behavior: .cache)
        
        case search(query: String)
        case details(id: String, language: String)
        case images(id: String)
        
        var relativePathURL: String {
            switch self {
                case .search: return "api/search"
                case .details: return "api/get"
                case .images: return "cdn/maps/roomfinder"
            }
        }
        
        var fullPathURL: String {
            switch self {
            case .search:
                return Self.baseURL + self.relativePathURL
            case .details(let id, _):
                return Self.baseURL + self.relativePathURL + "/" + id
            case .images(let id):
                return Self.baseURL + self.relativePathURL + "/" + id
            }
            
        }
        
        var fullRequestURL: String {
            self.fullPathURL + "?" + parameters.flatMap({ key, value in
                key + "=" + value
            })
        }
        
        var parameters: [String: String] {
            switch self {
                case .search(let query): return ["q": query]
                case .details(_, let language): return ["lang": language]
                case .images(_): return [:]
            }
        }
        
        var needsAuth: Bool {
            switch self {
                case .search, .details, .images: return false
            }
        }
        
        func asRequest(token: String?) -> DataRequest {
            guard !self.needsAuth else {
                fatalError("Not implemented")
            }
            
            return AF
                .request(self.fullPathURL, parameters: self.parameters)
                .cacheResponse(using: Self.responseCacherAF)
        }
    }
}
