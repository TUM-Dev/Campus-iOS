//
//  NewsManages.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft

final class NewsManager: CachedManager, SingleItemManager {
    
    typealias DataType = News
    
    var config: Config
    
    var cache = [News]()
    var isLoaded = false
    
    var requiresLogin: Bool {
        return false
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func toSingle(from items: [News]) -> DataElement? {
        return items.filter({ $0.date > .now }).first ?? items.last
    }
    
    func perform() -> Response<[News]> {
        return config.tumCabe.doObjectsRequest(to: .news).nested { $0.sorted(descending: { $0.date }) }
    }
    
}
