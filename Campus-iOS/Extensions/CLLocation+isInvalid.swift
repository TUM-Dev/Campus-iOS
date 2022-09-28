//
//  CLLocation+isInvalid.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 28.09.22.
//

import Foundation
import MapKit

extension CLLocation {
    func isInvalid() -> Bool {
        let lat = coordinate.latitude
        let lon = coordinate.longitude
        return lat < -90 || lat > 90 || lon < -180 || lon > 180
    }
}
