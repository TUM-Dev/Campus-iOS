//
//  API.swift
//  Abfahrt
//
//  Created by Lukas Kollmer on 16.06.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import CoreLocation
import Sweeft

final class MVGManager: SimpleTypedCardManager {
    
    var cardKey: CardKey = .mvg
    
    typealias DataType = Station
    
    var config: Config
    
    var requiresLogin: Bool {
        return false
    }
    
    init(config: Config) {
        self.config = config
    }
    
//    func fetch() -> Response<[Station]> {
//        return config.mvg.doObjectsRequest(to: .getNearbyStations,
//                                           queries: ["latitude" : location.coordinate.latitude,
//                                                     "longitude" : location.coordinate.longitude],
//                                           at: ["locations"]).map { $0.sorted(byLocation: \.location) }
//    }
    
    func fetch() -> Response<[Station]> {
        let promise: Response<[Station]> = config.mvg.doObjectsRequest(to: .getNearbyStations,
                                                   queries: ["latitude" : location.coordinate.latitude,
                                                             "longitude" : location.coordinate.longitude],
                                                   at: ["locations"]).map { $0.sorted(byLocation: \.location) }
        return promise.flatMap { (stations: [Station]) in
            return self.fetchDepartures(for: stations)
        }
    }
    
    func fetchDepartures(for stations: [Station]) -> Response<[Station]> {
        
        let map = stations.flatMap {self.fetchDeparture(for: $0)}
        
        let bulk = map.bulk.onSuccess { return $0 }
        return bulk
    }
    
    func fetchDeparture(for data: Station) -> Response<Station> {
        
        return config.mvg.doJSONRequest(to: .departure, arguments: ["id" : data.id], queries: [ "footway": 0 ]).map { (json: JSON) in
            let departures = json["departures"].array ==> Departure.init <** data
            data.departures = departures.array(withFirst: 5)
                return data
        }
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
