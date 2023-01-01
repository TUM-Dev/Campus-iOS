//
//  NavigationEntity.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 01.01.23.
//

import Foundation

struct NavigationEntity: Codable {
    let id: String
    let type: String
    let name: String
    let subtext: String
    let parsedId: String?

    enum CodingKeys: String, CodingKey {
        case id, type, name, subtext
        case parsedId = "parsed_id"
    }
}
