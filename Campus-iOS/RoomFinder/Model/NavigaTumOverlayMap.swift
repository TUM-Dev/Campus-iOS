//
//  NavigaTumOverlayMap.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 07.03.23.
//

import Foundation

struct NavigaTumOverlayMap: Codable, Identifiable {
    let id: Int
    let floor: String
    let imageUrl: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id, floor, name
        case imageUrl = "file"
    }
}
