//
//  NewsManages.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft

final class NewsManager: MemoryCachedManager, SingleItemCachedManager, CardManager {
    
    typealias DataType = News
    
    var config: Config
    var cache: Cache<[News]>?
    
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
    
    private func fetch(from news: String) -> Response<[News]> {
        return config.tumCabe.doObjectsRequest(to: .news,
                                               arguments: ["news" : news],
                                               maxCacheTime: .forever).flatMap { (results: [News]) in
            
            guard let lastId = results.max({ $0.id }) else {
                self.config.tumCabe.removeCache(for: .news, arguments: ["news" : news])
                return .successful(with: results)
            }
            return self.fetch(from: lastId).map { results + $0 }
                                           .mapError(to: results)
        }
    }
    
    func performRequest(maxCache: CacheTime) -> Promise<[News], APIError> {
        return fetch(from: "").map { $0.sorted(descending: \.date) }
    }
    
}
