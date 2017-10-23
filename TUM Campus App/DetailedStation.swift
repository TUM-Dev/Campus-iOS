//
//  DetailedStation.swift
//  Campus
//
//  Created by Mathias Quintero on 10/23/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Foundation

struct DetailedStation {
    let station: Station
    let departures: [Departure]
}

extension DetailedStation: DataElement {
    
    var text: String {
        return station.name
    }
    
    func getCellIdentifier() -> String {
        return "station"
    }
    
}
