//
//  API.swift
//  Abfahrt
//
//  Created by Lukas Kollmer on 16.06.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import CoreLocation
import Sweeft

final class MVGManager: Manager, SimpleSingleManager {
    
    typealias DataType = Station
    
    var config: Config
    
    var requiresLogin: Bool {
        return false
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func fetchSingle() -> Response<DataElement?> {
        return fetch().flatMap { stations in
            guard let station = stations.first else { return .successful(with: nil) }
            return self.fetch(for: station).map { departures in
                return DetailedStation(station: station, departures: departures)
            }
        }
    }
    
    func fetch() -> Response<[Station]> {
        return config.mvg.doObjectsRequest(to: .getNearbyStations,
                                           queries: ["latitude" : location.coordinate.latitude,
                                                     "longitude" : location.coordinate.longitude],
                                           at: ["locations"]).map { $0.sorted(byLocation: \.location) }
    }
    
}

extension MVGManager: DetailsForDataManager {
    
    func fetch(for data: Station) -> Response<[Departure]> {
        
        return config.mvg.doJSONRequest(to: .departure,
                                        arguments: ["id" : data.id],
                                        queries: [ "footway": 0 ]).map { (json: JSON) in
            
            return json["departures"].array ==> Departure.init <** data
        }
    }
    
}
