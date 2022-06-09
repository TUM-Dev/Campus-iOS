//
//  RoomImageMapping.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.06.22.
//

import Foundation

struct RoomImageMapping: Codable {
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
