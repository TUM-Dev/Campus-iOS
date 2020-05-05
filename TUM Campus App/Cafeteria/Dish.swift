//
//  Dish.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 5.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import Foundation
import CoreData

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
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let parameters = try? container.nestedContainer(keyedBy: Parameters.self, forKey: .students) {
            let basePrice = try parameters.decode(Decimal.self, forKey: .basePrice)
            let unitPrice = try parameters.decode(Decimal.self, forKey: .unitPrice)
            let unit = try parameters.decode(String.self, forKey: .unit)
            self = .student(basePrice: basePrice, unitPrice: unitPrice, unit: unit)
        } else if let parameters = try? container.nestedContainer(keyedBy: Parameters.self, forKey: .students) {
            let basePrice = try parameters.decode(Decimal.self, forKey: .basePrice)
            let unitPrice = try parameters.decode(Decimal.self, forKey: .unitPrice)
            let unit = try parameters.decode(String.self, forKey: .unit)
            self = .staff(basePrice: basePrice, unitPrice: unitPrice, unit: unit)
        } else if let parameters = try? container.nestedContainer(keyedBy: Parameters.self, forKey: .students) {
            let basePrice = try parameters.decode(Decimal.self, forKey: .basePrice)
            let unitPrice = try parameters.decode(Decimal.self, forKey: .unitPrice)
            let unit = try parameters.decode(String.self, forKey: .unit)
            self = .guest(basePrice: basePrice, unitPrice: unitPrice, unit: unit)
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Key not found"))
        }
    }

}

@objc final class Dish: NSManagedObject, Entity {

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

    enum CodingKeys: String, CodingKey {
        case name
        case prices
        case ingredients
        case dish_type
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let name = try container.decode(String.self, forKey: .name)
        let prices = try container.decode([Price].self, forKey: .prices)
        let ingredients = try container.decode([String].self, forKey: .ingredients)
        let dish_type = try container.decode(String.self, forKey: .dish_type)

        self.init(entity: Dish.entity(), insertInto: context)
        self.name = name
        self.ingredients = ingredients

        for price in prices {
            switch price {
            case let .student(basePrice, unitPrice, unit):
                self.students_base_price = NSDecimalNumber(decimal: basePrice)
                self.students_price_per_unit = NSDecimalNumber(decimal: unitPrice)
                self.students_unit = unit
            case let .staff(basePrice, unitPrice, unit):
                self.staff_base_price = NSDecimalNumber(decimal: basePrice)
                self.staff_price_per_unit = NSDecimalNumber(decimal: unitPrice)
                self.staff_unit = unit
            case let .guest(basePrice, unitPrice, unit):
                self.guests_base_price = NSDecimalNumber(decimal: basePrice)
                self.guest_price_per_unit = NSDecimalNumber(decimal: unitPrice)
                self.guest_unit = unit
            }
        }

        self.dish_type = dish_type
    }
    
}
