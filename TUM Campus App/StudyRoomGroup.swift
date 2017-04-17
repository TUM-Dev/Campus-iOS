//
//  StudyRoomGroup.swift
//  TUM Campus App
//
//  Created by Max Muth on 18.12.16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import SwiftyJSON

class StudyRoomGroup: DataElement {
    let sortId: Int
    let name: String
    let detail: String
    var roomNumbers = [Int]()
    
    init(sortId: Int, name: String, detail: String, roomNumbers: [Int]) {
        self.sortId = sortId
        self.name = name
        self.detail = detail
        self.roomNumbers = roomNumbers
    }
    
    convenience init?(from json: JSON) {
        guard let sortId = json["sortierung"].int, let name = json["name"].string, let detail = json["detail"].string, let roomNumbersArray = json["raeume"].array else {
            return nil
        }
        let numbers = roomNumbersArray.map { $0.int! }
        self.init(sortId: sortId, name: name, detail: detail, roomNumbers: numbers)
    }

    var text: String {
        return name
    }
    func getCellIdentifier() -> String {
        return "studyRoomGroup"
    }
}
