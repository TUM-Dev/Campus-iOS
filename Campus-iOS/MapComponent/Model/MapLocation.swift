//
//  MapLocation.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 08.07.22.
//

import Foundation
import MapKit

struct MapLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
