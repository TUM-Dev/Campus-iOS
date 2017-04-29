//
//  MovieManager.swift
//  
//
//  Created by Mathias Quintero on 12/6/15.
//
//

import Foundation
import Alamofire
import Sweeft
import SwiftyJSON

final class MovieManager: CachedManager {
    
    typealias DataType = Movie
    
    var config: Config
    
    var cache = [Movie]()
    var isLoaded = false
    
    var requiresLogin: Bool {
        return false
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func perform() -> Response<[Movie]> {
        return config.tumCabe.doObjectsRequest(to: .movie).nested { $0 |> { $0.airDate >= .now } }
    }
    
}
