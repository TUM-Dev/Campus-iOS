//
//  Cafeteria.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 17.12.21.
//

import Foundation
import MapKit

struct Location: Decodable, Hashable {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let address: String

    var coordinate: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
}

struct Queue: Decodable, Hashable {
    let current: Int
    let percent: Float
}

struct Cafeteria: Decodable, Hashable {
    /*
     "location": {
        "address": "Arcisstraße 17, München",
        "latitude": 48.147420,
        "longitude": 11.567220
     },
     "name": "Mensa Arcisstraße",
     "canteen_id": "mensa-arcisstr"
     },
 */
    let location: Location
    var name: String
    let id: String
    
    let queueStatusApi: String?
    var queue: Queue?

    var coordinate: CLLocationCoordinate2D { location.coordinate }
    var title: String? { name }

    enum CodingKeys: String, CodingKey {
        case location
        case name
        case id = "canteen_id"
        case queueStatusApi = "queue_status"
        case queue
    }
    
}

extension Array where Element == Cafeteria {
    mutating func sortByDistance(to location: CLLocation) {
        self.sort { (lhs,rhs) in
            let lhsDistance = lhs.coordinate.location.distance(from: location)
            let rhsDistance = rhs.coordinate.location.distance(from: location)
            return lhsDistance < rhsDistance
        }
    }
}

let mockCafeterias = [
    Cafeteria(location: Location(latitude: 48.147420, longitude: 11.567220, address: "Arcisstraße 17, München"), name: "Mensa Arcisstraße", id: "mensa-arcisstr", queueStatusApi: nil, queue: nil),
    // Mensa Garching has an maximum capacity of 1500 people (reversed calculated with the current and percentage of a day, e.g. current = 2 and percent: 0.13333334 then 0.13333334/100 * x = 2 => 2/(13333334/100) = 1500)
    Cafeteria(location: Location(latitude: 48.268132, longitude: 11.672263, address: "Boltzmannstraße 19, Garching"), name: "Mensa Garching", id: "mensa-garching", queueStatusApi: Optional("https://mensa.liste.party/api/"), queue: Queue(current: 150, percent: 0.1))
]
