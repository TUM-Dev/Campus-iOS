//
//  TuitionStatusManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft

final class TuitionStatusManager: MemoryCachedManager, SingleItemCachedManager, CardManager {
    
    typealias DataType = Tuition
    
    var config: Config
    var cache: Cache<[Tuition]>?
    
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
    
    func toSingle(from items: [Tuition]) -> DataElement? {
        return items.first { !$0.isPaid }
    }
    
    func performRequest(maxCache: CacheTime) -> Response<[Tuition]> {
        return config.tumOnline.doXMLObjectsRequest(to: .tuitionStatus,
                                                    at: "rowset", "row",
                                                    maxCacheTime: maxCache)
    }
    
}
