//
//  RoomFinderMaps.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 01.01.23.
//

import Foundation

struct NavigaTumRoomFinderMaps: Codable {
    let available: [NavigaTumRoomFinderMap]
    let defaultMapId: String
    
    enum CodingKeys: String, CodingKey {
        case available
        case defaultMapId = "default"
    }
}
