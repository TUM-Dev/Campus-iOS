//
//  Room.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 17.05.22.
//

import Foundation

struct FoundRoom: Codable, Hashable {
    /*
     {
        "room_id": "59773",
        "room_code": "5302.TP.208",
        "building_nr": "5302",
        "arch_id": "-1.208@5302",
        "info": "-1.208, Cleanroom\/EI. Mikroskop",
        "address": "Lichtenbergstr.    2(5302), Tiefparterre",
        "purpose": "Labor - Physik",
        "campus": "G",
        "name": "Garching"
     }
     */

    let roomId: String
    let roomCode: String
    let buildingNumber: String
    let id: String
    let info: String
    let address: String
    let purpose: String
    let campus: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case roomCode = "room_code"
        case buildingNumber = "building_nr"
        case id = "arch_id"
        case info
        case address
        case purpose
        case campus
        case name
    }

}
