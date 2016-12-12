//
//  RoomFinderMapManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RoomFinderMapManager: SearchManager {
    
    var request: Request?
    
    var main: TumDataManager?
    
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
                
                let maps: [Map?]? = parsed.array?
                    .map { map in
                        guard let description = map["description"].string,
                            let id = map["map_id"].int,
                            let scale = map["scale"].int else {
                                return nil
                        }
                        return Map(roomID: self.query ?? "", mapID: id.description, description: description, scale: scale)
                    }
                
                let result = maps?.flatMap { $0 } ?? []
                
                handler(result)
            }
        }
    }
    
    func getURL() -> String {
        let base = RoomFinderApi.BaseUrl.rawValue + RoomFinderApi.Maps.rawValue
        if let search = query {
            let url = base + search
            if let value = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) {
                return value
            }
        }
        return ""
    }
    
}
