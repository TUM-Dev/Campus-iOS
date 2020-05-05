//
//  MealPlan.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 5.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import Foundation
import CoreData

@objc final class MealPlan: NSManagedObject, Entity {

    /*
     {
        "number": 10,
        "year": 2020,
        "days": [...]
     }
     */
    
    enum CodingKeys: String, CodingKey {
        case week = "number"
        case year
        case days
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let year = try container.decode(Int64.self, forKey: .year)
        let week = try container.decode(Int64.self, forKey: .week)
        let days = try container.decode([Dish].self, forKey: .days)

        self.init(entity: MealPlan.entity(), insertInto: context)
        self.year = year
        self.week = week
        self.days = NSSet(object: days)
    }

}
