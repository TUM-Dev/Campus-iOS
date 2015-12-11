//
//  Room.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
class Room: DataElement {
    let code: String
    let name: String
    let building: String
    let campus: String
    let number: String
    
    init(code: String, name: String, building: String, campus: String, number: String) {
        self.code = code
        self.name = name
        self.building = building
        self.campus = campus
        self.number = number
    }
    
    func getCellIdentifier() -> String {
        return "room"
    }
    
    var text: String {
        return name
    }
    
}