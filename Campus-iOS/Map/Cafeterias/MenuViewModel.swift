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
    @Published var categories: [CategoryViewModel]
    
    init(title: String, categories: [CategoryViewModel]) {
        self.title = title
        self.categories = categories
    }
}

struct CategoryViewModel: Identifiable {
    let id = UUID()
    let name: String
    let dishes: [Dish]
    var isExpanded: Bool = false
    
    init(name: String, dishes: [Dish]) {
        self.name = name
        self.dishes = dishes
    }
}
