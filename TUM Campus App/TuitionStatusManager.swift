//
//  TuitionStatusManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft

final class TuitionStatusManager: CachedManager, SingleItemCachedManager, CardManager {
    
    typealias DataType = Tuition
    
    var config: Config
    
    var requiresLogin: Bool {
        return false
    }
    
    var defaultMaxCache: CacheTime {
        return .time(.aboutOneDay)
    }
    
    var cardKey: CardKey {
        return .tuition
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func fetch(maxCache: CacheTime) -> Response<[Tuition]> {
        return config.tumOnline.doXMLObjectsRequest(to: .tuitionStatus,
                                                    at: "rowset", "row",
                                                    maxCacheTime: maxCache)
    }
    
}
