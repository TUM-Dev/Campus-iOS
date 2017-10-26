//
//  DefaultCampus.swift
//  Campus
//
//  Created by Mathias Quintero on 10/23/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import CoreLocation
import Sweeft

enum Campus: Int, Codable {
    case garching
    case center
}

extension Campus {
    
    var location: CLLocation {
        switch self {
        case .garching:
            return .init(latitude: 48.264483, longitude: 11.670999)
        case .center:
            return .init(latitude: 48.149073, longitude: 11.567485)
        }
    }
    
}

struct DefaultCampus: SingleStatus {
    static var key: AppDefaults = .campus
    static var defaultValue: Campus = .garching
}
