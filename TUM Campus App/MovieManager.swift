//
//  MovieManager.swift
//  
//
//  Created by Mathias Quintero on 12/6/15.
//
//

import Foundation
import Sweeft

final class MovieManager: SingleItemManager {
    
    typealias DataType = Movie
    
    var config: Config
    
    var requiresLogin: Bool {
        return false
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func fetch() -> Response<[Movie]> {
        return config.tumCabe.doObjectsRequest(to: .movie,
                                               maxCacheTime: .time(.aboutOneDay)).map { $0 |> { $0.airDate >= .now } }
    }
    
}
