//
//  Dish.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 5.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import Foundation

struct Price2: Decodable {
    let basePrice: Decimal?
    let unitPrice: Decimal?
    let unit: String?

    enum CodingKeys: String, CodingKey {
        case basePrice = "base_price"
        case unitPrice = "price_per_unit"
        case unit
    }

}

enum Price: Decodable {
    case student(basePrice: Decimal, unitPrice: Decimal, unit: String)
    case staff(basePrice: Decimal, unitPrice: Decimal, unit: String)
    case guest(basePrice: Decimal, unitPrice: Decimal, unit: String)

    /*
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
     ...
     */

    enum CodingKeys: String, CodingKey {
        case students
        case staff
        case guests
    }

    enum Parameters: String, CodingKey {
        case basePrice = "base_price"
        case unitPrice = "price_per_unit"
        case unit
    }


    init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)

        if let parameters = try? container.nestedContainer(keyedBy: Parameters.self, forKey: .students) {
            let basePrice = try! parameters.decode(Decimal.self, forKey: .basePrice)
            let unitPrice = try! parameters.decode(Decimal.self, forKey: .unitPrice)
            let unit = try! parameters.decode(String.self, forKey: .unit)
            self = .student(basePrice: basePrice, unitPrice: unitPrice, unit: unit)
        } else if let parameters = try? container.nestedContainer(keyedBy: Parameters.self, forKey: .students) {
            let basePrice = try! parameters.decode(Decimal.self, forKey: .basePrice)
            let unitPrice = try! parameters.decode(Decimal.self, forKey: .unitPrice)
            let unit = try! parameters.decode(String.self, forKey: .unit)
            self = .staff(basePrice: basePrice, unitPrice: unitPrice, unit: unit)
        } else if let parameters = try? container.nestedContainer(keyedBy: Parameters.self, forKey: .students) {
            let basePrice = try! parameters.decode(Decimal.self, forKey: .basePrice)
            let unitPrice = try! parameters.decode(Decimal.self, forKey: .unitPrice)
            let unit = try! parameters.decode(String.self, forKey: .unit)
            self = .guest(basePrice: basePrice, unitPrice: unitPrice, unit: unit)
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Key not found"))
        }
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
    let prices: [String: Price2]
    let ingredients: [String]
    let dishType: String

    lazy var namedIngredients: [String] = {
        ingredients.map { (ingredientsLookup[$0] ?? $0) }
    }()

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
