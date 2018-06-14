//
//  Room.swift
//  TUM Campus App
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
