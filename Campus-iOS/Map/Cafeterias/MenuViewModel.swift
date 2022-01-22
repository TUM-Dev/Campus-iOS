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
<<<<<<< HEAD
    let date: Date
    @Published var categories: [CategoryViewModel]
    
    init(title: String, date: Date, categories: [CategoryViewModel]) {
        self.title = title
        self.date = date
=======
    @Published var categories: [CategoryViewModel]
    
    init(title: String, categories: [CategoryViewModel]) {
        self.title = title
>>>>>>> 01b55bc (Draft some kind of viewmodel (#396))
        self.categories = categories
    }
}

struct CategoryViewModel: Identifiable {
<<<<<<< HEAD
    var id = UUID()
    var name: String
    var dishes: [Dish]
=======
    let id = UUID()
    let name: String
    let dishes: [Dish]
>>>>>>> 01b55bc (Draft some kind of viewmodel (#396))
    var isExpanded: Bool = false
    
    init(name: String, dishes: [Dish]) {
        self.name = name
        self.dishes = dishes
    }
}
