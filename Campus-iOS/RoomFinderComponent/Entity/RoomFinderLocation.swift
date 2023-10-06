//
//  NavigaTumLocation.swift
//  Campus-iOS
//
//  Created by Jakob Paul Körber on 06.10.23.
//

import Foundation
import MapKit

struct RoomFinderLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
