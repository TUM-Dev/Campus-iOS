//
//  CalendarManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft

final class CalendarManager: CachedManager, CardManager, SingleItemCachedManager {
    
    typealias DataType = CalendarRow
    
    var config: Config
    
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
        return items.first { $0.start > .now }
    }
    
    func fetch(maxCache: CacheTime) -> Response<[CalendarRow]> {
        return config.tumOnline.doXMLObjectsRequest(to: .calendar,
                                                    at: "events", "event",
                                                    maxCacheTime: maxCache).map { $0.filter { $0.status == "FT" } }
    }
    
}
