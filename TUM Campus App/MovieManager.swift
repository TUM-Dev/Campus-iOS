//
//  MovieManager.swift
//  
//
//  Created by Mathias Quintero on 12/6/15.
//
//

import Foundation
import Sweeft

final class MovieManager: MemoryCachedManager, SingleItemCachedManager, CardManager {
    
    typealias DataType = Movie
    
    var config: Config
    var cache: Cache<[Movie]>?
    
    var requiresLogin: Bool {
        return false
    }
    
    var cardKey: CardKey {
        return .tufilm
    }
    
    var defaultMaxCache: CacheTime {
        return .time(.aboutOneDay)
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func performRequest(maxCache: CacheTime) -> Response<[Movie]> {
        return config.tumCabe.doObjectsRequest(to: .movie,
                                               maxCacheTime: maxCache).map { $0 |> { $0.airDate >= .now } }
    }
    
}
