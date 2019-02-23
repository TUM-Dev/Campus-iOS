//
//  TUMSexyAPI.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/23/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Alamofire

enum TUMSexyAPI: URLRequestConvertible {
    static let baseURLString = "https://json.tum.sexy"
    
    var method: HTTPMethod {
        switch self {
        default: return .get
        }
    }
    
    static var requiresAuth: [String] = []
    
    func asURLRequest() throws -> URLRequest {
        let url = try TUMCabeAPI.baseURLString.asURL()
        let urlRequest = try URLRequest(url: url, method: method, headers: TUMCabeAPI.baseHeaders)
        return urlRequest
    }
    
}
