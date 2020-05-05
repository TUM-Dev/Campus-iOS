//
//  Menu.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 5.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import Foundation
import CoreData


@objc final class Menu: NSManagedObject, Entity {

    /*
     "date": "2020-03-02",
     "dishes": [...]
     */

    enum CodingKeys: String, CodingKey {
        case date
        case dishes
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let date = try container.decode(Date.self, forKey: .date)
        let dishes = try container.decode([Dish].self, forKey: .dishes)

        self.init(entity: Menu.entity(), insertInto: context)
        self.date = date
        self.dishes = NSSet(object: dishes)
    }

}
