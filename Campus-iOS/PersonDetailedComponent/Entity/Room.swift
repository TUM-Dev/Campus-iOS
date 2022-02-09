//
//  Room.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 06.02.22.
//

import Foundation

struct Room: Decodable {
    let number: String
    let buildingName: String
    let buildingNumber: String
    let floorName: String
    let floorNumber: String
    let id: String
    let locationDescription: String
    let shortLocationDescription: String
    let longLocationDescription: String

    enum CodingKeys: String, CodingKey {
        case number = "nummer"
        case buildingName = "gebaeudename"
        case buildingNumber = "gebaeudenummer"
        case floorName = "stockwerkname"
        case floorNumber = "stockwerknummer"
        case id = "architekt"
        case locationDescription = "ortsbeschreibung"
        case shortLocationDescription = "kurz"
        case longLocationDescription = "lang"
    }
}
