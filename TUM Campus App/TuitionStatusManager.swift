//
//  TuitionStatusManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft

final class TuitionStatusManager: SingleItemManager {
    
    typealias DataType = Tuition
    
    var config: Config
    
    var requiresLogin: Bool {
        return false
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func fetch() -> Response<[Tuition]> {
        return config.tumOnline.doXMLObjectsRequest(to: .tuitionStatus,
                                                    at: "rowset", "row",
                                                    maxCacheTime: .time(.aboutOneDay))
    }
    
}
