//
//  RoomMap.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 24.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import Foundation

struct RoomMap: Codable {
    /*
     {
     "map_id": 54,
     "description": "München",
     "scale": 200000,
     "width": 640,
     "height": 603
     },
     */

    let id: Int
    let description: String
    let scale: Int
    let width: Int
    let height: Int

    enum CodingKeys: String, CodingKey {
        case id = "map_id"
        case description
        case scale
        case width
        case height
    }
}
