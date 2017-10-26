//
//  StudyRoomGroup.swift
//  TUM Campus App
//
//  Created by Max Muth on 18.12.16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
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
