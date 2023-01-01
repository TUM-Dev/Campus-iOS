//
//  NavigationDetails.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 01.01.23.
//

import Foundation

struct NavigationDetails: Codable {
    let id: String
    let name: String
    let parentNames: [String]
    let type: String
    let typeCommonName: String
    let additionalProperties: NavigationAdditionalProperties
    let coordinates: NavigationCoordinates
    let maps: NavigationMaps
    
    enum CodingKeys: String, CodingKey {
        case id, name, parentNames, type, maps
        case typeCommonName = "type_common_name"
        case additionalProperties = "props"
        case coordinates = "coords"
    }
}
