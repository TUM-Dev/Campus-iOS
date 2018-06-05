//
//  Station.swift
//  Abfahrt
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

public enum Line {
    case bus(Int)
    case nachtbus(Int)
    
    case tram(Int)
    case nachttram(Int)
    
    case ubahn(Int)
    case sbahn(Int)
    
    case other(Int)
}

extension Line {
    
    init?(key: String, number: Int) {
        switch key {
        case "bus":
            self = .bus(number)
        case "nachtbus":
            self = .nachtbus(number)
        case "tram":
            self = .tram(number)
        case "nachttram":
            self = .nachttram(number)
        case "ubahn":
            self = .ubahn(number)
        case "sbahn":
            self = .sbahn(number)
        case "otherlines":
            self = .other(number)
        default:
            return nil
        }
    }
    
}

public struct Station: Hashable {
    
    public var hashValue: Int { return self.id.hashValue }
    
    public let name: String
    public let id: Int
    
    public let type: String
    
    public let place: String
    
    public let hasZoomData: Bool
    public let hasLiveData: Bool
    
    public let latitude: Double
    public let longitude: Double
    
    public let lines: [Line]
    
    /// Distance from the search location
    public let distance: Int?
}

extension Station: Deserializable {
    
    public init?(from json: JSON) {
        guard let name = json["name"].string,
            let id   = json["id"].int,
            let type   = json["type"].string,
            let hasLiveData = json["hasLiveData"].double?.bool,
            let hasZoomData = json["hasZoomData"].double?.bool,
            let latitude = json["latitude"].double,
            let longitude = json["longitude"].double,
            let place = json["place"].string,
            let lines = json["lines"].dict else { return nil }
        
        self.name = name
        self.id = id
        self.type = type
        self.hasLiveData = hasLiveData
        self.hasZoomData = hasZoomData
        self.latitude = latitude
        self.longitude = longitude
        self.place = place
        self.distance = json["distance"].int
        
        self.lines = lines.flatMap { key, value -> [Line] in
            guard let numbers = value.array?.flatMap({ $0.int }) else {
                return []
            }
            return numbers.flatMap { Line(key: key, number: $0) }
        }
    }
    
}

extension Station {
    
    var location: CLLocation {
        return .init(latitude: latitude, longitude: longitude)
    }
    
}

extension Station: DataElement {
    
    var text: String {
        return name
    }
    
    func getCellIdentifier() -> String {
        return "station"
    }
    
    
}

public func ==(lhs: Station, rhs: Station) -> Bool {
    return lhs.id == rhs.id
}
