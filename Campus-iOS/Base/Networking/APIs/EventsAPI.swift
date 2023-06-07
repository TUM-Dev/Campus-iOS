//
//  EventsAPI.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 07.06.23.
//

import Foundation
import Alamofire

enum EventsAPI: API {
    case talks
    
    static var baseURL: String = "https://tum.events/api/"

    static var baseHeaders: Alamofire.HTTPHeaders = []
    
    static var error: APIError.Type = NavigaTUMAPIError.self
    
    var paths: String {
        switch self {
        case .talks: return "talks"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .talks: return [:]
        }
    }
    
    var needsAuth: Bool {
        switch self {
        case .talks: return false
        }
    }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        return try JSONDecoder().decode(type, from: data)
    }
}
