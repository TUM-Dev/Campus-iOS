//
//  RoomSearchManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft

final class RoomSearchManager: SearchManager {
    
    typealias DataType = Room
    
    var config: Config
    
    var categoryKey: SearchResultKey {
        return .room
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func search(query: String) -> Promise<[Room], APIError> {
        return config.tumCabe.doObjectsRequest(to: .searchRooms, arguments: ["query" : query])
    }

}
