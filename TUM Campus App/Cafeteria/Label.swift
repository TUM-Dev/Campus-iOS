//
//  Label.swift
//  TUMCampusApp
//
//  Created by Philipp Wenner on 12.01.22.
//  Copyright © 2022 TUM. All rights reserved.
//

import Foundation

struct Label: Decodable {

    /*
     [
       {
         "enum_name": "VEGETARIAN",
         "text": {
           "DE": "Vegetarisch",
           "EN": "vegetarian"
         },
         "abbreviation": "🌽"
       }
     ]
     */

    let name: String
    let text: [String: String]
    let abbreviation: String
    
    enum CodingKeys: String, CodingKey {
        case name = "enum_name"
        case text
        case abbreviation
    }
}
