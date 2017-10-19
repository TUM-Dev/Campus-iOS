//
//  Departure.swift
//  Abfahrt
//
//  Created by Lukas Kollmer on 17.06.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import SwiftyJSON

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
    
    
    init(json: JSON, station: Station) {
        self.departureTime = Date(millisecondsSince1970: json["departureTime"].intValue)
        self.product       = json["product"].stringValue
        self.label         = json["label"].stringValue
        self.destination   = json["destination"].stringValue
        self.live          = json["live"].boolValue
        self.lineBackgroundColor = json["lineBackgroundColor"].stringValue
        self.departureId   = json["departureId"].intValue
        self.sev           = json["sev"].boolValue
        
        self.station = station
    }
}
