//
//  NewsManages.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft

final class NewsManager: CachedManager, SingleItemCachedManager, CardManager {
    
    typealias DataType = News
    
    var config: Config
    
    var requiresLogin: Bool {
        return false
    }
    
    var cardKey: CardKey {
        return .news
    }
    
    var defaultMaxCache: CacheTime {
        return .time(.aboutOneDay)
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func toSingle(from items: [News]) -> DataElement? {
        return items.filter({ $0.date > .now }).last ?? items.first
    }
    
    func fetch(maxCache: CacheTime) -> Response<[News]> {
        return config.tumCabe.doObjectsRequest(to: .news,
                                               maxCacheTime: maxCache).map { $0.sorted(descending: \.date) }
    }
    
}
