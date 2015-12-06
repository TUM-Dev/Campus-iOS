//
//  Cafeteria.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import CoreLocation

class Cafeteria:DataElement {
    
    let address: String
    let id: Int
    let name: String
    
    let location: CLLocation

    init(id: Int, name: String, address: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.address = address
        location = CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func distance(from: CLLocation) -> CLLocationDistance {
        return from.distanceFromLocation(location)
    }
    
}