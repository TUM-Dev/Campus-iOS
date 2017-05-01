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

final class StudyRoomsManager: CachedManager {
    
    typealias DataType = StudyRoomGroup
    
    var config: Config
    
    var cache = [StudyRoomGroup]()
    var isLoaded = false
    
    var requiresLogin: Bool {
        return false
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func perform() -> Response<[StudyRoomGroup]> {
        return config.rooms.doJSONRequest(to: .rooms).nested { json in
            return json["gruppen"].array ==> StudyRoomGroup.init
        }
    }
    
}
    
