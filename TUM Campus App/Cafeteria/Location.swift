//
//  Location.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 4.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

//@objc final class Location: NSManagedObject, Entity {
//
//    /*
//     "location": {
//        "address": "Arcisstraße 17, München",
//        "latitude": 48.147420,
//        "longitude": 11.567220
//     }
//     */
//
//    var coordinate: CLLocationCoordinate2D {
//        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case address
//        case latitude
//        case longitude
//    }
//
//    required convenience init(from decoder: Decoder) throws {
//        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let latitude = try container.decode(Double.self, forKey: .latitude)
//        let longitude = try container.decode(Double.self, forKey: .longitude)
//        let address = try container.decode(String.self, forKey: .address)
//
//        self.init(entity: Location.entity(), insertInto: context)
//        self.latitude = latitude
//        self.longitude = longitude
//        self.address = address
//    }
//
//}
