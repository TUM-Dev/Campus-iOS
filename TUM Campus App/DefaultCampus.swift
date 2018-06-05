//
//  DefaultCampus.swift
//  Campus
//
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
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
