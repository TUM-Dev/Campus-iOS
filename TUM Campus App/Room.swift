//
//  Room.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//


import Sweeft

final class Room: DataElement {
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

extension Room: Deserializable {
    
    convenience init?(from json: JSON) {
        guard let code = json["room_id"].string,
            let architectNumber = json["arch_id"].string,
            let name = json["info"].string,
            let building = json["name"].string,
            let campus = json["campus"].string else {
                return nil
        }
        self.init(code: code, name: name, building: building, campus: campus, number: architectNumber)
    }

}
