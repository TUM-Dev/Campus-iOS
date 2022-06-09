//
//  MealPlanViewModel.swift
//  Campus-iOS
//
//  Created by Tim Gymnich on 19.01.22.
//

import Foundation
import SwiftUI


final class MenuViewModel: ObservableObject, Identifiable {
    let id = UUID()
    let date: Date
    @Published var categories: [MenuCategory]
    
    init(date: Date, categories: [MenuCategory]) {
        self.date = date
        self.categories = categories
    }
}

struct MenuCategory: Identifiable {
    let id = UUID()
    let name: String
    let dishes: [Dish]
  
    init(name: String, dishes: [Dish]) {
        self.name = name
        self.dishes = dishes
    }
}
