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
    
    func search(query: String) -> Promise<[UserData], APIError> {
        return config.tumOnline.doRepresentedRequest(to: .personSearch,
                                                     queries: ["pSuche" : query]).map { (xml: XMLIndexer) in
            
            return xml.get(at: ["rowset", "row"])?.all ==> { UserData(from: $0, api: self.config.tumOnline) }
        }
    }
    
}
