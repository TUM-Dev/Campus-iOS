//
//  RoomFinderMapManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

class RoomFinderMapManager: SearchManager {
    
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
                print(parsedXML)
                var mapsArray = [DataElement]()
                let maps = parsedXML["maps"]["map"].all
                for map in maps {
                    if let description = map["description"].element?.text, id = map["id"].element?.text {
                        let newMap = Map(roomID: self.query ?? "", mapID: id, description: description)
                        mapsArray.append(newMap)
                    }
                }
                handler(mapsArray)
            }
        }
    }
    
    func getURL() -> String {
        let base = RoomFinderApi.BaseUrl.rawValue + RoomFinderApi.Maps.rawValue
        if let search = query {
            let url = base + "?" + "&id=" + search
            if let value = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet()) {
                return value
            }
        }
        return ""
    }
    
}