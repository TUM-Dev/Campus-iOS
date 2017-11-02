//
//  TUMSexyAPI.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 5/1/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Sweeft

struct TUMSexyEndpoint: APIEndpoint {
    
    static let sexy = TUMSexyEndpoint()
    
    var rawValue: String {
        return ""
    }
    
}

struct TUMSexyAPI: API {
    
    typealias Endpoint = TUMSexyEndpoint
    
    let baseURL: String
    
}
