//
//  TUMSexyAPI.swift
//  Campus-iOS
//
//  Created by David Lin on 10.02.23.
//

import Foundation
import Alamofire

enum TUMSexyAPI: API {
    case standard
    
    static var baseURL: String = "https://json.tum.sexy/"
    
    static var baseHeaders: Alamofire.HTTPHeaders = []
    
    static var error: APIError.Type = TUMSexyAPIError.self
    
    var paths: String { "" }
    
    var parameters: [String : String] { [:] }
    
    var needsAuth: Bool { false }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        return try JSONDecoder().decode(type, from: data)
    }
}
