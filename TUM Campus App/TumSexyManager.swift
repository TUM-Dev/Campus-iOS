//
//  TumSexyManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 3/28/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Sweeft

final class TumSexyManager: CachedManager {
    
    typealias DataType = SexyEntry
    
    var config: Config
    
    var cache = [SexyEntry]()
    var isLoaded = true
    
    var requiresLogin: Bool {
        return false
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func perform() -> Response<[SexyEntry]> {
        return config.tumSexy.doJSONRequest(to: .sexy).nested { (json: JSON) in
            return json.dict ==> SexyEntry.init
        }
    }
    
}
