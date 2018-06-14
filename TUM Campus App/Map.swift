//
//  Map.swift
//  TUM Campus App
//
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
//

import Foundation
import Sweeft

final class Map: DataElement {
    let roomID: String
    let mapID: String
    let description: String
    let scale: Int
    let image: Image
    
    init(roomID: String, mapID: String, description: String, scale: Int, api: TUMCabeAPI) {
        self.roomID = roomID
        self.mapID = mapID
        self.description = description
        self.scale = scale
        
        let url = api.url(for: TUMCabeEndpoint.mapImage, arguments: ["room": roomID, "id": mapID])
        image = .init(url: url.absoluteString)
    }
    
    convenience init?(roomID: String, api: TUMCabeAPI, from json: JSON) {
        guard let description = json["description"].string,
            let id = json["map_id"].int,
            let scale = json["scale"].int else {
                return nil
        }
        self.init(roomID: roomID,
                  mapID: id.description,
                  description: description,
                  scale: scale,
                  api: api)
    }
    
    func getCellIdentifier() -> String {
        return "map"
    }
    
    var text: String {
        return description
    }
    
}
