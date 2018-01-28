//
//  PersonSearchManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/8/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft
import SWXMLHash

final class PersonSearchManager: SearchManager {
    
    typealias DataType = UserData
    
    var config: Config
    
    var cache = [UserData]()
    var isLoaded = false
    
    var requiresLogin: Bool {
        return false
    }
    
    var categoryKey: SearchResultKey {
        return .person
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func search(query: String, maxCache: CacheTime) -> Response<[UserData]> {
        return config.tumOnline.doXMLObjectsRequest(to: .personSearch,
                                                    queries: ["pSuche" : query],
                                                    at: "rowset", "row",
                                                    maxCacheTime: maxCache)
    }
    
    func search(query: String) -> Promise<[UserData], APIError> {
        return search(query: query, maxCache: .no)
    }
    
}
