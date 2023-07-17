//
//  MensaCategory.swift
//  Campus-iOS
//
//  Created by David Lin on 02.04.23.
//

import Foundation

struct MenuCategory: Identifiable, Decodable {
    var id = UUID()
    let name: String
    let dishes: [Dish]
  
    init(name: String, dishes: [Dish]) {
        self.name = name
        self.dishes = dishes
    }
}
