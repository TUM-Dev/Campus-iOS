//
//  Dish.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 17.12.21.
//

import Foundation

struct Price: Hashable, Decodable {
    let basePrice: Decimal?
    let unitPrice: Decimal?
    let unit: String?

    enum CodingKeys: String, CodingKey {
        case basePrice = "base_price"
        case unitPrice = "price_per_unit"
        case unit
    }
}

struct Dish: Decodable, Hashable {

    /*
     {
        "name": "Pasta all'arrabiata",
        "prices": {
            "students": {
                "base_price": 0.0,
                "price_per_unit": 0.33,
                "unit": "100g"
            },
            "staff": {
                "base_price": 0.0,
                "price_per_unit": 0.55,
                "unit": "100g"
            },
            "guests": {
                "base_price": 0.0,
                "price_per_unit": 0.66,
                "unit": "100g"
            }
        },
        "labels": [
                  "VEGETARIAN"
        ]
     
        "dish_type": "Pasta"
    },
     */

    let name: String
    var prices: [String: Price]
    let labels: [String]
    let dishType: String

    enum CodingKeys: String, CodingKey {
        case name
        case prices
        case labels
        case dishType = "dish_type"
    }
    
    static func == (lhs: Dish, rhs: Dish) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(name);
    }
}
