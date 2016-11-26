//
//  RoomSearchManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Alamofire
import SwiftyJSON

class RoomSearchManager: SearchManager {
    
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
                
                let roomsArray: [Room?]? = parsed.array?
                    .map { room in
                        guard let code = room["room_id"].string,
                            let architectNumber = room["arch_id"].string,
                            let name = room["info"].string,
                            let building = room["name"].string,
                            let campus = room["campus"].string else {
                                return nil
                        }
                        return Room(code: code, name: name, building: building, campus: campus, number: architectNumber)
                    }
                
                let result = roomsArray?.flatMap { $0 } ?? []
                
                handler(result)
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
