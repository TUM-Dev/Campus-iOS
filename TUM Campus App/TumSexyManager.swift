//
//  TumSexyManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 3/28/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Sweeft
import Fuzzi

struct SexyIndex {
    let entries: [SexyEntry]
    let tree: SearchTree<SexyEntry>?
}

final class TumSexyManager: MemoryCachedManager, SearchManager {
    
    typealias DataType = SexyEntry
    
    var config: Config
    var indexCache: Cache<SexyIndex>?
    
    var cache: Cache<[SexyEntry]>? {
        get {
            return indexCache.map { $0.map { $0.entries } }
        }
        set {
            indexCache = newValue.map { $0.map { .init(entries: $0, tree: $0.searchTree()) } }
        }
    }
    
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
        guard let tree = defaultMaxCache.validValue(in: indexCache)?.tree else {
            return fetch().flatMap { _ in
                return self.search(query: query)
            }
        }
        return async(runQueue: .global()) {
            return tree.search(query: query)
        }
    }
    
    func performRequest(maxCache: CacheTime) -> Response<[SexyEntry]> {
        return config.tumSexy.doJSONRequest(to: .sexy,
                                            maxCacheTime: maxCache).map { (json: JSON) in
            return json.dict ==> SexyEntry.init
        }
    }
    
}
