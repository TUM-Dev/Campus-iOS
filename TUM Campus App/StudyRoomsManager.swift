//
//  StudyRoomManager.swift
//  TUM Campus App
//
//  Created by Max Muth on 17.12.16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

import Sweeft

final class StudyRoomsManager: NewManager {
    
    typealias DataType = StudyRoomGroup
    
    var config: Config
    
    var requiresLogin: Bool {
        return false
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func fetch() -> Response<[StudyRoomGroup]> {
        return config.rooms.doJSONRequest(to: .rooms).map { json in
            return json["gruppen"].array ==> StudyRoomGroup.init
        }
    }
    
}
    
