//
//  TumSexyManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 3/28/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Sweeft
import Fuzzi

final class TumSexyManager: MemoryCachedManager, SearchManager {
    
    typealias DataType = SexyEntry
    
    var config: Config
    var tree: SearchTree<SexyEntry>?
    var cache: Cache<[SexyEntry]>?
    
    var requiresLogin: Bool {
        return false
    }
    
    var defaultMaxCache: CacheTime {
        return .time(.aboutOneWeek)
    }
    
    var categoryKey: SearchResultKey {
        return .sexy
    }
    
    init(config: Config) {
        self.config = config
    }

    func search(query: String) -> Promise<[SexyEntry], APIError> {
        guard let tree = tree else {
            return fetch().flatMap { entries in
                self.tree = entries.tree()
                return self.search(query: query)
            }
        }
        return async(runQueue: .global()) {
            return tree.search(query: query).array
        }
    }

    func performRequest(maxCache: CacheTime) -> Response<[SexyEntry]> {
        return config.tumSexy.doJSONRequest(to: .sexy,
                                            maxCacheTime: maxCache).map { (json: JSON) in
            return json.dict ==> SexyEntry.init
        }
    }
    
}
