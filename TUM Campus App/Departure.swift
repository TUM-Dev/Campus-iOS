//
//  Departure.swift
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

import Foundation
import Sweeft

struct Departure {
    let departureTime: Date
    let product: String
    let label: String
    let destination: String
    let live: Bool
    let lineBackgroundColor: String
    let departureId: Int
    let sev: Bool
    
    let station: Station
    
    init?(json: JSON, station: Station) {
        guard let departureTime = json["departureTime"].int,
            let product = json["product"].string,
            let label = json["label"].string,
            let destination = json["destination"].string,
            let live = json["live"].double?.bool,
            let lineBackgroundColor = json["lineBackgroundColor"].string,
            let departureId = json["departureId"].int,
            let sev = json["sev"].double?.bool else {
                return nil
        }
        
        self.departureTime = Date(millisecondsSince1970: departureTime)
        self.product = product
        self.label = label
        self.destination = destination
        self.live = live
        self.lineBackgroundColor = lineBackgroundColor
        self.departureId = departureId
        self.sev = sev
        self.station = station
    }
}
