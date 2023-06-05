//
//  TUMDevAppAPI.swift
//  Campus-iOS
//
//  Created by David Lin on 10.02.23.
//

import Foundation
import Alamofire

enum TUMDevAppAPI: API {
    case room(roomNr: Int)
    case rooms
    
    static var baseURL: String = "https://www.devapp.it.tum.de/"
    
    static var baseHeaders: Alamofire.HTTPHeaders = []
    
    static var error: APIError.Type = TUMDevAppAPIError.self
    
    var paths: String {
        switch self {
        case .room, .rooms:             return "iris/ris_api.php"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .room(roomNr: let roomNr):
            return ["format": "json", "raum": String(roomNr)]
        case .rooms:
            return ["format": "json"]
        }
    }
    
    var needsAuth: Bool { false }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        return try JSONDecoder().decode(type, from: data)
    }
}
