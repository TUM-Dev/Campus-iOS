//
//  API.swift
//  Abfahrt
//
//  Created by Lukas Kollmer on 16.06.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import CoreLocation
import Sweeft

// TODO: Refactor This

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
        return config.mvg.doObjectsRequest(to: .queryStationsByName,
                                           queries: ["q" : ""],
                                           at: ["locations"]).map { (stations: [Station]) in
                                            
            return stations.sorted(byLocation: \.location)
        }
    }
    
}

struct MVG {
    
//    fileprivate func makeRequest(_ endpoint: Endpoint, _ parameters: Parameters, clearCache: Bool = false, responseHandler: @escaping (Error?, JSON?) -> ()) throws {
//        var url = endpoint.rawValue
//        var params = parameters
//
//        if endpoint == .departure {
//            guard let id = params["id"] as? Int else { throw NSError() } // todo throw real error
//            url += String(id)
//
//            params.removeValue(forKey: "id")
//        }
//
//        if clearCache {
//            URLCache.shared.removeAllCachedResponses()
//        }
//
//        Alamofire.request(url, parameters: params, headers: Credentials.AuthHeader).responseData { response in
//            guard let data = response.data else { responseHandler(response.error, nil); return }
//
//            responseHandler(response.error, JSON(data: data))
//        }
//    }
//
//
//
//    func getAllStations(handler: @escaping (Error?, [Station]) -> ()) {
//        // Querying by name, but passing an empty string will return all stations
//
//        try! makeRequest(.queryStationsByName, ["q" : ""]) { error, response in
//
//            guard let locations = response?["locations"].array else {
//                handler(error, [])
//                return
//            }
//            var stations = [Station]()
//
//            for stationInfo in locations {
//                if let station = Station(json: stationInfo) {
//                    stations.append(station)
//                }
//            }
//
//            handler(nil, stations)
//        }
//    }
//
//
//
//    func getNearbyStations(atLocation location: CLLocation, _ handler: @escaping (Error?, [Station]) -> Void) {
//
//        let parameters: Parameters = [
//            "latitude" : location.coordinate.latitude,
//            "longitude" : location.coordinate.longitude
//        ]
//
//        try! makeRequest(.getNearbyStations, parameters) { error, json in
//            guard let json = json else {
//                handler(error, [])
//                return
//            }
//
//            var stations = [Station]()
//
//            for (_, location) in json["locations"] {
//                if let station = Station(json: location) {
//                    stations.append(station)
//                }
//            }
//
//            handler(error, stations)
//        }
//    }
//
//
//    func getDepartures(forStation station: Station, handler: @escaping (Error?, [Departure]?) -> ()) {
//        let params: Parameters = [
//            "id" : station.id,
//            "footway" : 0
//        ]
//
//        var departures: [Departure] = []
//
//        try! makeRequest(.departure, params, clearCache: true) { error, json in
//            guard let departuresJSON = json?["departures"].array else {
//                handler(error, nil)
//                return
//            }
//
//            for departure in departuresJSON {
//                departures.append(Departure(json: departure, station: station))
//            }
//
//            handler(error, departures)
//        }
//    }
//
//    func getInterruptions(handler: @escaping (Error?, [Interruption]) -> ()) {
//        try! makeRequest(.interruptions, [:], clearCache: true) { error, json in
//            guard let interruptionsJSON = json?["interruption"].array else {
//                handler(error, [])
//                return
//            }
//
//            let interruptions: [Interruption] = interruptionsJSON.map { Interruption(json: $0) }
//
//            handler(nil, interruptions)
//        }
//    }
}


