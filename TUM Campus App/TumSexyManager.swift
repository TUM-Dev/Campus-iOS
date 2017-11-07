//
//  TumSexyManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 3/28/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Sweeft

final class TumSexyManager: MemoryCachedManager {
    
    typealias DataType = SexyEntry
    
    var config: Config
    var cache: Cache<[SexyEntry]>?
    
    var requiresLogin: Bool {
        return false
    }
    
    var defaultMaxCache: CacheTime {
        return .time(.aboutOneWeek)
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func performRequest(maxCache: CacheTime) -> Response<[SexyEntry]> {
        return config.tumSexy.doJSONRequest(to: .sexy,
                                            maxCacheTime: maxCache).map { (json: JSON) in
            return json.dict ==> SexyEntry.init
        }
    }
    
}
