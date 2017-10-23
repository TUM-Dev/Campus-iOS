//
//  Departure.swift
//  Abfahrt
//
//  Created by Lukas Kollmer on 17.06.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
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
