//
//  Cafeteria.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/22/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import CoreData
import MapKit

struct Location: Decodable {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let address: String

    var coordinate: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
}

@objc final class Cafeteria: NSManagedObject, Entity, MKAnnotation {
    
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

    var coordinate: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
    var title: String? { name }

    enum CodingKeys: String, CodingKey {
        case location
        case name
        case id = "canteen_id"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let location = try container.decode(Location.self, forKey: .location)

        self.init(entity: Cafeteria.entity(), insertInto: context)
        self.id = id
        self.name = name
        self.address = location.address
        self.longitude = location.longitude
        self.latitude = location.latitude
    }
    
}
