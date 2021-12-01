//
//  TUMDevAppAPI.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/23/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import Alamofire

enum TUMDevAppAPI: URLRequestConvertible {
    case cafeteria(id: Int)
    case cafeterias
    case room(roomNr: Int)
    case rooms
    
    static let baseURLString = "https://www.devapp.it.tum.de"
    
    var path: String {
        switch self {
        case .cafeteria, .cafeterias:   return "mensaapp/exportDB.php"
        case .room, .rooms:             return "iris/ris_api.php"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .get
        }
    }
    
    static var requiresAuth: [String] = []
    
    func asURLRequest() throws -> URLRequest {
        let url = try TUMDevAppAPI.baseURLString.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        
        switch self {
        case .rooms:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["format": "json"])
        case .room(let roomNr):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["format": "json", "raum": roomNr])
        case .cafeteria(let id):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["mensa_id": id])
        case .cafeterias:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["mensa_id": "all"])
        }
        return urlRequest
    }
    
}

