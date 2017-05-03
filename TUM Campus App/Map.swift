//
//  Map.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft

final class Map: ImageDownloader, DataElement {
    let roomID: String
    let mapID: String
    let description: String
    let scale: Int
    
    init(roomID: String, mapID: String, description: String, scale: Int) {
        self.roomID = roomID
        self.mapID = mapID
        self.description = description
        self.scale = scale
        super.init()
        
        // TODO:
        
        //let url = RoomFinderApi.BaseUrl.rawValue +  RoomFinderApi.MapImage.rawValue + roomID + "/" + mapID
        // if let sanitizedURL = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) {
           // getImage(sanitizedURL)
        //}
    }
    
    convenience init?(roomID: String, from json: JSON) {
        guard let description = json["description"].string,
            let id = json["map_id"].int,
            let scale = json["scale"].int else {
                return nil
        }
        self.init(roomID: roomID, mapID: id.description, description: description, scale: scale)
    }
    
    func getCellIdentifier() -> String {
        return "map"
    }
    
    var text: String {
        return description
    }
    
}
