//
//  NavigationAdditionalProperties.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 01.01.23.
//

import Foundation

struct NavigaTumNavigationAdditionalProperties: Codable {
    let properties: [NavigaTumNavigationProperty]
    
    enum CodingKeys: String, CodingKey {
        case properties = "computed"
    }
}
