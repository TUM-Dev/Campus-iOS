//
//  NavigaTUMAPI.swift
//  Campus-iOS
//
//  Created by David Lin on 10.04.23.
//

import Foundation
import Alamofire

enum NavigaTUMAPI: API {
    case search(query: String)
    case details(id: String, language: String)
    case images(id: String)
    case overlayImages(id: String)
    
    static var baseURL: String = "https://nav.tum.de/"
    
    static var baseHeaders: Alamofire.HTTPHeaders = []
    
    static var error: APIError.Type = NavigaTUMAPIError.self
    
    var paths: String {
        switch self {
            case .search: return "api/search"
            case .details(let id, _): return "api/get" + "/" + id
            case .images(let id): return "cdn/maps/roomfinder" + "/" + id
            case .overlayImages(let id): return "cdn/maps/overlay" + "/" + id
        }
    }
    
    var parameters: [String : String] {
        switch self {
            case .search(let query): return ["q": query]
            case .details(_, let language): return ["lang": language]
            case .images(_): return [:]
            case .overlayImages(_): return [:]
        }
    }
    
    var needsAuth: Bool {
        switch self {
        case .search, .details, .images, .overlayImages: return false
        }
    }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        return try JSONDecoder().decode(type, from: data)
    }
}
