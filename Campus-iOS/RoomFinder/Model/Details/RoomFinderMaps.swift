//
//  RoomFinderMaps.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 01.01.23.
//

import Foundation

struct RoomFinderMaps: Codable {
    let available: [RoomFinderMap]
    let defaultMapId: String
    
    enum CodingKeys: String, CodingKey {
        case available
        case defaultMapId = "default"
    }
}
