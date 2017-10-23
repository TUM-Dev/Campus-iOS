//
//  MVGAPI.swift
//  Campus
//
//  Created by Mathias Quintero on 10/23/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Sweeft

enum MVGAPIEndpoint: String, APIEndpoint {
    case getNearbyStations = "fahrinfo/api/location/nearby"
    case departure = "fahrinfo/api/departure/{id}"
}

struct MVGAPI: API {
    
    typealias Endpoint = MVGAPIEndpoint
    
    let baseURL: String
    let apiKey: String
    
    var baseHeaders: [String : String] {
        return [
            "X-MVG-Authorization-Key": apiKey,
        ]
    }
    
}
