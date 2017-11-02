//
//  RoomFinderMapManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft

final class RoomFinderMapManager: SearchManager {
    
    typealias DataType = Map
    
    var config: Config
    
    var categoryKey: SearchResultKey {
        return .room
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func search(query: String) -> Response<[Map]> {
        return config.tumCabe.doJSONRequest(to: .roomMaps,
                                            arguments: ["room" : query]).map { (json: JSON) in
                                                
            return json.array ==> { Map(roomID: query, api: self.config.tumCabe, from: $0) }
        }
    }
    
}
