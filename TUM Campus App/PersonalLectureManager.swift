//
//  PersonSearchManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/8/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft

final class PersonalLectureManager: CachedManager {
    
    typealias DataType = Lecture
    
    var config: Config
    
    var cache = [Lecture]()
    var isLoaded = false
    
    var requiresLogin: Bool {
        return false
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func perform() -> Response<[Lecture]> {
        return config.tumOnline.doXMLObjectsRequest(to: .personalLectures, at: "rowset", "row")
    }
    
}
