//
//  StudyRoomGroup.swift
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

class StudyRoomGroup: DataElement {
    let sortId: Int
    let name: String
    let detail: String
    let rooms: [StudyRoom]
    
    init(sortId: Int, name: String, detail: String, rooms: [StudyRoom]) {
        self.sortId = sortId
        self.name = name
        self.detail = detail
        self.rooms = rooms
    }
    
    convenience init?(from json: JSON, rooms: [StudyRoom]) {
        guard let sortId = json["sortierung"].int,
            let name = json["name"].string,
            let detail = json["detail"].string else {
            return nil
        }
        
        let numbers = json["raeume"].array ==> { $0.int }
        self.init(sortId: sortId, 
                  name: name, 
                  detail: detail, 
                  rooms: rooms.filter { numbers.contains($0.roomNumber) })
    }

    var text: String {
        return name
    }
    func getCellIdentifier() -> String {
        return "studyRoomGroup"
    }
    
}
