//
//  MVGAPI.swift
//  Campus
//
//  Created by Mathias Quintero on 10/23/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Sweeft

enum MVGAPIEndpoint: String, APIEndpoint {
    case queryStationById = "fahrinfo/api/location/query"
    case queryStationsByName = "fahrinfo/api/location/queryWeb"
    case getNearbyStations = "fahrinfo/api/location/nearby"
    case departure = "fahrinfo/api/departure/"
    case interruptions = ".rest/betriebsaenderungen/api/interruptions"
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
