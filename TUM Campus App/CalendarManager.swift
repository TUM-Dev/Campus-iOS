//
//  CalendarManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft

final class CalendarManager: CachedManager, SingleItemManager {
    
    typealias DataType = CalendarRow
    
    var config: Config
    
    var cache = [CalendarRow]()
    var isLoaded = false
    
    var requiresLogin: Bool {
        return false
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func toSingle(from items: [CalendarRow]) -> DataElement? {
        let new = items |> { $0.dtstart! > .now } // TODO:
        return new.first
    }
    
    func perform() -> Response<[CalendarRow]> {
        return config.tumOnline.doXMLObjectsRequest(to: .calendar, at: "events", "event")
    }
    
}
