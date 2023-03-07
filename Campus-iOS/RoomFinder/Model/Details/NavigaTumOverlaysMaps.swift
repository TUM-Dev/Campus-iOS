//
//  NavigaTumOverlaysMaps.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 07.03.23.
//

import Foundation

struct NavigaTumOverlaysMaps: Codable {
    let available: [NavigaTumOverlayMap]
    let defaultMapId: String?

    enum CodingKeys: String, CodingKey {
        case available
        case defaultMapId = "default"
    }
}
