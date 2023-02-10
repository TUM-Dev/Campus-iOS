//
//  MVGAPI.swift
//  Campus-iOS
//
//  Created by David Lin on 10.02.23.
//

import Foundation
import Alamofire

enum MVGAPI: API {
    case nearby(latitude: String, longitude: String)
    case departure(id: Int)
    case station(name: String)
    case id(id: Int)
    case interruptions
    
    static var baseURL: String = "https://www.mvg.de/"
    
    static let apiKey = "5af1beca494712ed38d313714d4caff6"
    static var baseHeaders: Alamofire.HTTPHeaders = ["X-MVG-Authorization-Key": apiKey]
    
    static var error: APIError.Type = MVGAPIError.self
    
    var paths: String {
        switch self {
        case .nearby:               return "fahrinfo/api/location/nearby"
        case .departure(let id):    return "fahrinfo/api/departure/\(id)"
        case .station:              return "fahrinfo/api/location/queryWeb"
        case .id:                   return "fahrinfo/api/location/query"
        case .interruptions:        return ".rest/betriebsaenderungen/api/interruption"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .station(name: let name):
            return ["q": name]
        case .id(id: let id):
            return ["q": String(id)]
        case .departure(id: _):
            return ["footway": String(0)]
        case .nearby(latitude: let latitude, longitude: let longitude):
            return ["latitude": latitude, "longitude": longitude]
        default:
            return [:]
        }
    }
    
    var needsAuth: Bool { false }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        return try JSONDecoder().decode(type, from: data)
    }
}
