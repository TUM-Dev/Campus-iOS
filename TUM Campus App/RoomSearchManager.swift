//
//  RoomSearchManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Alamofire
import Sweeft
import SwiftyJSON

class RoomSearchManager: SearchManager {
    
    var request: Request?
    
    var main: TumDataManager?
    
    var requiresLogin: Bool {
        return false
    }
    
    var query: String?
    
    func setQuery(_ query: String) {
        self.query = query
    }
    
    required init(mainManager: TumDataManager) {
        main = mainManager
    }
    
    func fetchData(_ handler: @escaping ([DataElement]) -> ()) {
        request?.cancel()
        let url = getURL()
        request = Alamofire.request(url).responseJSON() { (response) in
            if let value = response.result.value {
                let parsed = JSON(value)
                parsed.array ==> Room.init | handler
            }
        }
    }
    
    func getURL() -> String {
        let base = RoomFinderApi.BaseUrl.rawValue + RoomFinderApi.SearchRooms.rawValue
        if let search = query {
            let url = base + search
            if let value = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
                return value
            }
        }
        return ""
    }
}
