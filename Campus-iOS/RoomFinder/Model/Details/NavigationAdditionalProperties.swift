//
//  NavigationAdditionalProperties.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 01.01.23.
//

import Foundation

struct NavigationAdditionalProperties: Codable {
    let properties: [NavigationProperty]
    
    enum CodingKeys: String, CodingKey {
        case properties = "computed"
    }
}
