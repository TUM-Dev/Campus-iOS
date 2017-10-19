//
//  PersonSearchManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/8/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft

final class PersonSearchManager: SearchManager {
    
    typealias DataType = UserData
    
    var config: Config
    
    var cache = [UserData]()
    var isLoaded = false
    
    var requiresLogin: Bool {
        return false
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func search(query: String) -> Promise<[UserData], APIError> {
        return config.tumOnline.doXMLObjectsRequest(to: .personSearch, queries: ["pSuche" : query], at: "rowset", "row")
    }
    
}
