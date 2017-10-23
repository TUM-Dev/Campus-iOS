//
//  API.swift
//  Abfahrt
//
//  Created by Lukas Kollmer on 16.06.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import CoreLocation
import Sweeft

final class MVGManager: NewManager {
    
    typealias DataType = Station
    
    var config: Config
    
    var requiresLogin: Bool {
        return false
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func fetch() -> Response<[Station]> {
        return location.map { location in
            
            return config.mvg.doObjectsRequest(to: .getNearbyStations,
                                               queries: ["latitude" : location.coordinate.latitude,
                                                         "longitude" : location.coordinate.longitude],
                                               at: ["locations"]).map { $0.sorted(byLocation: \.location) }
        } ?? .successful(with: [])
    }
    
}

extension MVGManager: DetailsForDataManager {
    
    func fetch(for data: Station) -> Response<[Departure]> {
        
        return config.mvg.doJSONRequest(to: .departure,
                                        queries: [
                                            "id" : data.id,
                                            "footway": 0,
                                        ]).map { (json: JSON) in
            
            return json["departures"].array ==> Departure.init <** data
        }
    }
    
}
