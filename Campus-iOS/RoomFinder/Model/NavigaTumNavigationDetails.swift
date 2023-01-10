//
//  NavigationDetails.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 01.01.23.
//

import Foundation

struct NavigaTumNavigationDetails: Codable {
    let id: String
    let name: String
    let parentNames: [String]
    let type: String
    let typeCommonName: String
    let additionalProperties: NavigaTumNavigationAdditionalProperties
    let coordinates: NavigaTumNavigationCoordinates
    let maps: NavigaTumNavigationMaps
    
    enum CodingKeys: String, CodingKey {
        case id, name, type, maps
        case typeCommonName = "type_common_name"
        case additionalProperties = "props"
        case coordinates = "coords"
        case parentNames = "parent_names"
    }
}
