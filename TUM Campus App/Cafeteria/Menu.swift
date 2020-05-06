//
//  Menu.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 5.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import Foundation

struct Menu: Decodable, Comparable {
    /*
     "date": "2020-03-02",
     "dishes": [...]
     */

    let date: Date?
    let dishes: [Dish]
    lazy var categories: [(name: String, dishes: [Dish])] = {
        dishes.reduce(into: [:]) { (acc: inout [String: [Dish]], dish: Dish) -> () in
            let type = dish.dishType.isEmpty ? "Sonstige" : dish.dishType
            if acc[type] != nil {
                acc[type]?.append(dish)
            }
            acc[type] = [dish]
        }.map{ return ($0,$1) }
    }()

    enum CodingKeys: String, CodingKey {
        case date
        case dishes
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.date = try container.decode(Date.self, forKey: .date)
        self.dishes = try container.decode([Dish].self, forKey: .dishes)
    }

    static func < (lhs: Menu, rhs: Menu) -> Bool {
        if let lhsDate = lhs.date, let rhsDate = rhs.date {
            return lhsDate < rhsDate
        }
        return lhs.date == nil
    }

    static func == (lhs: Menu, rhs: Menu) -> Bool {
        return lhs.date == rhs.date 
    }
}
