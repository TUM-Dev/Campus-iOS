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
    let name: String
    let id: String

    var coordinate: CLLocationCoordinate2D { location.coordinate }
    var title: String? { name }

    enum CodingKeys: String, CodingKey {
        case location
        case name
        case id = "canteen_id"
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
