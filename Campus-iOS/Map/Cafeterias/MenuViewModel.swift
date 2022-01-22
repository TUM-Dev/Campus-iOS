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
    let title: String
    let date: Date
    @Published var categories: [CategoryViewModel]
    
    init(title: String, date: Date, categories: [CategoryViewModel]) {
        self.title = title
        self.date = date
        self.categories = categories
    }
}

struct CategoryViewModel: Identifiable {
    var id = UUID()
    var name: String
    var dishes: [Dish]
    var isExpanded: Bool = false
    
    init(name: String, dishes: [Dish]) {
        self.name = name
        self.dishes = dishes
    }
}
