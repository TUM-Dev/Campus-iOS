//
//  API.swift
//  Abfahrt
//
//  Created by Lukas Kollmer on 16.06.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import CoreLocation
import Sweeft

final class MVGManager: Manager, CardManager {
    
    typealias DataType = Station
    
    let cardKey: CardKey = .mvg
    
    var config: Config
    
    var requiresLogin: Bool {
        return false
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func fetch() -> Response<[Station]> {
        return config.mvg.doObjectsRequest(to: .getNearbyStations,
                                           queries: ["latitude" : location.coordinate.latitude,
                                                     "longitude" : location.coordinate.longitude],
                                           at: ["locations"]).map { $0.sorted(byLocation: \.location) }
    }
    
    func fetchCardsItems() -> Response<CardCategory?> {
        let stations = fetch().map { $0.array(withFirst: 3) }
        return stations.map { (stations: [Station]) in
            guard !stations.isEmpty else {
                return nil
            }
            let elements = stations => DetailedStation.init <** self
            return CardCategory(key: self.cardKey, elements: elements)
        }
    }
    
}

extension MVGManager: DetailsForDataManager {
    
    func fetch(for data: Station) -> Response<[Departure]> {
        
        return config.mvg.doObjectsRequest(to: .departure,
                                           arguments: ["id" : data.id],
                                           queries: [ "footway": 0 ],
                                           at: ["departures"])
    }
    
}
