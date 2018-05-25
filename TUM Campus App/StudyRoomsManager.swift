//
//  StudyRoomManager.swift
//  TUM Campus App
//
//  Created by Max Muth on 17.12.16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft

final class StudyRoomsManager: MemoryCachedManager, SingleItemCachedManager, CardManager {
    
    typealias DataType = StudyRoomGroup
    
    var config: Config
    var cardKey: CardKey = .studyRooms
    var cache: Cache<[StudyRoomGroup]>?
    
    var requiresLogin: Bool {
        return false
    }
    
    var defaultMaxCache: CacheTime {
        return .time(.aboutOneDay)
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func performRequest(maxCache: CacheTime) -> Promise<[StudyRoomGroup], APIError> {
        return config.rooms.doJSONRequest(to: .rooms, maxCacheTime: maxCache).map { (json: JSON) in
            let rooms = json["raeume"].array ==> StudyRoom.init(from:)
            return json["gruppen"].array ==> StudyRoomGroup.init <** rooms
        }
    }
    
    func fetch() -> Response<[StudyRoomGroup]> {
        return config.rooms.doJSONRequest(to: .rooms).map { (json: JSON) in
            let rooms = json["raeume"].array ==> StudyRoom.init(from:)
            return json["gruppen"].array ==> StudyRoomGroup.init <** rooms
        }
    }
    
}
    
