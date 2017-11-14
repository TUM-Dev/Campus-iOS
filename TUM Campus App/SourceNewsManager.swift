//
//  SourceNewsManager.swift
//  Campus
//
//  Created by Mathias Quintero on 11/13/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Sweeft

protocol SourceNewsManager: SingleItemCachedManager, CardManager where DataType == News {
    var newsManager: NewsManager { get }
    var source: News.Source { get }
    init(newsManager: NewsManager)
}

extension SourceNewsManager {
    
    var requiresLogin: Bool {
        return false
    }
    
    var cardKey: CardKey {
        return .news
    }
    
    var defaultMaxCache: CacheTime {
        return newsManager.defaultMaxCache
    }
    
    func toSingle(from items: [News]) -> DataElement? {
        return items.filter({ $0.date > .now }).last ?? items.first
    }
    
    func fetch(maxCache: CacheTime) -> Response<[DataType]> {
        return newsManager.fetch(maxCache: maxCache).map { $0 |> { self.source.contains($0.source) } }
    }
    
}
