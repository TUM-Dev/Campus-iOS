//
//  RoomSearchManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Alamofire
import SWXMLHash

class RoomSearchManager: SearchManager {
    
    var request: Request?
    
    var main: TumDataManager?
    
    var query: String?
    
    func setQuery(query: String) {
        self.query = query
    }
    
    required init(mainManager: TumDataManager) {
        main = mainManager
    }
    
    func fetchData(handler: ([DataElement]) -> ()) {
        request?.cancel()
        let url = getURL()
        request = Alamofire.request(.GET, url).responseString() { (response) in
            if let value = response.result.value {
                let parsedXML = SWXMLHash.parse(value)
                var roomsArray = [DataElement]()
                let campuses = parsedXML["campuses"]["campus"].all
                for campus in campuses {
                    if let campusName = campus["title"].element?.text {
                        let buildings = campus["building"].all
                        for building in buildings {
                            if let buildingName = building["title"].element?.text {
                                let rooms = building["room"].all
                                for room in rooms {
                                    if let code = room.element?.attributes["api_code"], architectNumber = room["architect_number"].element?.text, name = room["title"].element?.text {
                                        let newRoom = Room(code: code, name: name, building: buildingName, campus: campusName, number: architectNumber)
                                        roomsArray.append(newRoom)
                                    }
                                }
                            }
                        }
                    }
                }
                handler(roomsArray)
            }
        }
    }
    
    func getURL() -> String {
        let base = RoomFinderApi.BaseUrl.rawValue + RoomFinderApi.SearchRooms.rawValue
        if let search = query {
            let url = base + "?" + "&s=" + search
            if let value = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet()) {
                return value
            }
        }
        return ""
    }
}