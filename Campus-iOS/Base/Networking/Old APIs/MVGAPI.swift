//
//  MVGAPI.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/23/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import Alamofire

enum MVGAPI: URLRequestConvertible {
    case nearby(latitude: String, longitude: String)
    case departure(id: Int)
    case station(name: String)
    case id(id: Int)
    case interruptions
    
    static let baseURL = "https://www.mvg.de"
    static let apiKey = "5af1beca494712ed38d313714d4caff6"
    static let baseHeaders: HTTPHeaders = ["X-MVG-Authorization-Key": apiKey]
    
    var path: String {
        switch self {
        case .nearby:               return "fahrinfo/api/location/nearby"
        case .departure(let id):    return "fahrinfo/api/departure/\(id)"
        case .station:              return "fahrinfo/api/location/queryWeb"
        case .id:                   return "fahrinfo/api/location/query"
        case .interruptions:        return ".rest/betriebsaenderungen/api/interruption"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .get
        }
    }
    
    static var requiresAuth: [String] = []
    
    func asURLRequest() throws -> URLRequest {
        let url = try MVGAPI.baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        
        switch self {
            
        case .station(let name):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["q": name])
        case .id(let id):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["q": id])
        case .departure:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["footway": 0])
        case .nearby(let latitude, let longitude):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["latitude": latitude, "longitude": longitude])
        default:
            break
        }

        return urlRequest
    }
}
