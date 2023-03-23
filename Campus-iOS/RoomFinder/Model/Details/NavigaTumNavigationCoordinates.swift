//
//  NavigationCoordinates.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 01.01.23.
//

import Foundation

struct NavigaTumNavigationCoordinates: Codable {
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
