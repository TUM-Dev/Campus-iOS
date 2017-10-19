//
//  PersonalGradeManager.swift
//  TUM Campus App
//
//  Created by Florian Gareis on 04.02.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Sweeft

final class PersonalGradeManager: NewManager {
    
    typealias DataType = Grade
    
    var config: Config
    
    var requiresLogin: Bool {
        return false
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func fetch() -> Response<[Grade]> {
        return config.tumOnline.doXMLObjectsRequest(to: .personalGrades,
                                                    at: "rowset", "row",
                                                    maxCacheTime: .time(.aboutOneWeek))
    }
    
}
