//
//  Organization.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 06.02.22.
//

import Foundation

struct Organisation: Decodable {
    let name: String
    let id: String
    let number: String
    let title: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case name = "org"
        case id = "kennung"
        case number = "org_nr"
        case title = "titel"
        case description = "beschreibung"
    }
}
