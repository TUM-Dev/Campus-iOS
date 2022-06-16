//
//  MealPlan.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 17.12.21.
//

import Foundation

struct MealPlan: Decodable {

    /*
     {
        "number": 10,
        "year": 2020,
        "days": [...]
     }
     */

    let week: Int
    let year: Int
    let days: [MensaMenu]
    
    enum CodingKeys: String, CodingKey {
        case week = "number"
        case year
        case days
    }
}
