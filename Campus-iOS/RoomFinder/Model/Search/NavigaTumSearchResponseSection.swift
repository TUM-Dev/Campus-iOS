//
//  NavigaTumSearchResponseSection.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 01.01.23.
//

import Foundation

struct NavigaTumSearchResponseSection: Codable {
    let type: String
    let entries: [NavigationEntity]
    
    enum CodingKeys: String, CodingKey {
        case type = "facet"
        case entries
    }
}
