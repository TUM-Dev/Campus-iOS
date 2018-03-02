//
//  PersonalGradeManager.swift
//  TUM Campus App
//
//  Created by Florian Gareis on 04.02.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Sweeft

final class PersonalGradeManager: MemoryCachedManager {
    
    typealias DataType = Grade
    
    var config: Config
    var cache: Cache<[Grade]>?
    
    var requiresLogin: Bool {
        return false
    }
    
    var defaultMaxCache: CacheTime {
        return .time(.aboutOneWeek)
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func performRequest(maxCache: CacheTime) -> Promise<[Grade], APIError> {
        
        return config.tumOnline.doXMLObjectsRequest(to: .personalGrades,
                                                    at: "rowset", "row",
                                                    maxCacheTime: maxCache)
    }
    
}
