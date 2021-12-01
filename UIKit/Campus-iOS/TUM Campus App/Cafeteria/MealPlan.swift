//
//  MealPlan.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 5.5.20.
//  Copyright © 2020 TUM. All rights reserved.
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
    let days: [Menu]
    
    enum CodingKeys: String, CodingKey {
        case week = "number"
        case year
        case days
    }
}
