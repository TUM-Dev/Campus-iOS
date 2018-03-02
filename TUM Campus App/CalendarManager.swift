//
//  CalendarManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft

final class CalendarManager: MemoryCachedManager, CardManager, SingleItemCachedManager {
    
    typealias DataType = CalendarRow
    
    var config: Config
    var cache: Cache<[CalendarRow]>?
    
    var defaultMaxCache: CacheTime {
        return .time(.aboutOneWeek)
    }
    
    var cardKey: CardKey {
        return .calendar
    }
    
    var requiresLogin: Bool {
        return false
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func toSingle(from items: [CalendarRow]) -> DataElement? {
        return items.first { $0.irrelevantAfter > .now && $0.status == "FT" }
    }
    
    func performRequest(maxCache: CacheTime) -> Response<[CalendarRow]> {
        return config.tumOnline.doXMLObjectsRequest(to: .calendar,
                                                    at: "events", "event",
                                                    maxCacheTime: maxCache)
    }
    
}
