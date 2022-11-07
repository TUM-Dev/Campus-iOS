//
//  MockLocationManager.swift
//  Campus-iOSTests
//
//  Created by Robyn Kölle on 07.11.22.
//

import Foundation
import CoreLocation

class MockLocationManager: CLLocationManager {
    
    private let latitude: Double
    private let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        super.init()
    }
    
    override open var authorizationStatus: CLAuthorizationStatus {
        get {
            return .authorizedAlways
        }
    }
    
    override open var location: CLLocation? {
        get {
            return CLLocation(latitude: self.latitude, longitude: self.longitude)
        }
    }
}
