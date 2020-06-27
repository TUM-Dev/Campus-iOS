//
//  Dish.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 5.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import Foundation

struct Price: Decodable {
    let basePrice: Decimal?
    let unitPrice: Decimal?
    let unit: String?

    enum CodingKeys: String, CodingKey {
        case basePrice = "base_price"
        case unitPrice = "price_per_unit"
        case unit
    }

}

struct Dish: Decodable {

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
        "ingredients": [
            "2",
            "Gl",
            "GlW",
            "Kn"
        ],
        "dish_type": "Pasta"
    },
     */

    let name: String
    let prices: [String: Price]
    let ingredients: [String]
    let dishType: String

    var namedIngredients: [String] {
        ingredients.map { (ingredientsLookup[$0] ?? $0) }
    }

    private var ingredientsLookup = [
        "GQB" : "GQB",
        "MSC" : "MSC",

        "1" : "dyed",
        "2" : "preservative",
        "3" : "antioxidant",
        "4" : "flavor enhancers",
        "5" : "sulphured",
        "6" : "blackened (olive)",
        "7" : "waxed",
        "8" : "phosphates",
        "9" : "sweeteners",
        "10" : "contains a source of phenylalanine",
        "11" : "sugar and sweeteners",
        "13" : "cocoa-containing grease",
        "14" : "gelatin",
        "99" : "alcohol",

        "f" : "meatless dish",
        "v" : "vegan dish",
        "S" : "pork",
        "R" : "beef",
        "K" : "veal",
        "G" : "poultry", // mediziner mensa
        "W" : "wild meat", // mediziner mensa
        "L" : "lamb", // mediziner mensa
        "Kn" : "garlic",
        "Ei" : "chicken egg",
        "En" : "peanut",
        "Fi" : "fish",
        "Gl" : "gluten-containing cereals",
        "GlW" : "wheat",
        "GlR" : "rye",
        "GlG" : "barley",
        "GlH" : "oats",
        "GlD" : "spelt",
        "Kr" : "crustaceans",
        "Lu" : "lupines",
        "Mi" : "milk and lactose",
        "Sc" : "shell fruits",
        "ScM" : "almonds",
        "ScH" : "hazelnuts",
        "ScW" : "Walnuts",
        "ScC" : "cashew nuts",
        "ScP" : "pistachios",
        "Se" : "sesame seeds",
        "Sf" : "mustard",
        "Sl" : "celery",
        "So" : "soy",
        "Sw" : "sulfur dioxide and sulfites",
        "Wt" : "mollusks",
    ]

    enum CodingKeys: String, CodingKey {
        case name
        case prices
        case ingredients
        case dishType = "dish_type"
    }

}
