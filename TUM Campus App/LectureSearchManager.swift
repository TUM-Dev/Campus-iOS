//
//  LectureSearchManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/10/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft

final class LectureSearchManager: SearchManager {
    
    typealias DataType = Lecture
    
    var config: Config
    
    var categoryKey: SearchResultKey {
        return .lecture
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func search(query: String) -> Promise<[Lecture], APIError> {
        return config.tumOnline.doXMLObjectsRequest(to: .lectureSearch, queries: ["pSuche" : query], at: "rowset", "row")
    }
    
}
