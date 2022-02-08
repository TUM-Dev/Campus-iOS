//
//  PhoneExtension.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 06.02.22.
//

import Foundation

struct PhoneExtension: Decodable {
    let phoneNumber: String
    let countryCode: String
    let areaCode: String
    let equipmentNumber: String
    let branchNumber: String

    enum CodingKeys: String, CodingKey {
        case phoneNumber = "telefonnummer"
        case countryCode = "tum_anlage_land"
        case areaCode = "tum_anlage_ortsvorwahl"
        case equipmentNumber = "tum_anlage_nummer"
        case branchNumber = "tum_nebenstelle"
    }
}
