//
//  MealPlanViewModel.swift
//  Campus-iOS
//
//  Created by Tim Gymnich on 19.01.22.
//

import Foundation
import SwiftUI

final class cafeteriaMenu: Identifiable, Decodable {
    var id = UUID()
    let date: Date
    var categories: [MenuCategory]
    
    init(date: Date, categories: [MenuCategory]) {
        self.date = date
        self.categories = categories
    }
    
    func getDishes() -> [Dish]  {
        var dishes: [Dish] = []
        for category in categories {
            for dish in category.dishes {
                dishes.append(dish)
            }
        }
        
        return dishes.sorted(by: { $0.name < $1.name })
    }
}

struct MenuCategory: Identifiable, Decodable {
    var id = UUID()
    let name: String
    let dishes: [Dish]
  
    init(name: String, dishes: [Dish]) {
        self.name = name
        self.dishes = dishes
    }
}
