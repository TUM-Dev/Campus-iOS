//
//  NewsManages.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft

final class NewsManager: CachedManager, TypedCachedCardManager {
    
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
    
    func cardsItems(from elements: [News]) -> [News] {
        let future = elements.filter { $0.date > .now }
        let past = elements.filter { $0.date <= .now }
        return future.array(withLast: 1) + past.array(withFirst: 4)
    }
    
    func fetch(maxCache: CacheTime) -> Response<[News]> {
        return config.tumCabe.doObjectsRequest(to: .news,
                                               maxCacheTime: maxCache).map { $0.sorted(descending: \.date) }
    }
    
}
