//
//  Label.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 14.01.22.
//

import Foundation

 struct DishLabel: Decodable {

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
