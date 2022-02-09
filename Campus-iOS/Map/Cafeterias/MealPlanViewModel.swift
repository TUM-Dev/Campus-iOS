//
//  File.swift
//  Campus-iOS
//
//  Created by Tim Gymnich on 19.01.22.
//

import Foundation
import SwiftUI
import Alamofire

final class MealPlanViewModel: ObservableObject {
    private let cafeteria: Cafeteria
    private let endpoint = EatAPI.canteens
    private let sessionManager = Session.defaultSession

    @Published private(set) var title: String
    @Published private(set) var menus: [MenuViewModel] = []
    
    init(cafeteria: Cafeteria) {
        self.cafeteria = cafeteria
        self.title = cafeteria.name
    }
    
    func fetch() {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        let thisWeekEndpoint = EatAPI.menu(location: cafeteria.id, year: Date().year, week: Date().weekOfYear)
        
        sessionManager.request(thisWeekEndpoint).responseDecodable(of: MealPlan.self, decoder: decoder) { [self] response in
            guard let mealPlans = response.value else { return }
            self.menus = mealPlans.days
                .filter { !$0.dishes.isEmpty && ($0.date.isToday || $0.date.isLaterThanOrEqual(to: Date())) }
                .sorted { $0.date < $1.date }
                .map {
                    let categories = $0.dishes
                        .sorted { $0.dishType < $1.dishType }
                        .reduce(into: [:]) { (acc: inout [String: [Dish]], dish: Dish) -> () in
                            let type = dish.dishType.isEmpty ? "Sonstige" : dish.dishType
                            if acc[type] != nil {
                                acc[type]?.append(dish)
                            }
                            acc[type] = [dish]
                        }
                        .map { CategoryViewModel(name: $0.key, dishes: $0.value) }
                                        
                    return MenuViewModel(title: formatter.string(from: $0.date), date: $0.date, categories: categories) }
        }
        
        guard let nextWeek =  Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) else { return }
        
        let nextWeekEndpoint = EatAPI.menu(location: cafeteria.id, year: nextWeek.year, week: nextWeek.weekOfYear)
        
        sessionManager.request(nextWeekEndpoint).responseDecodable(of: MealPlan.self, decoder: decoder) { [self] response in
            guard let mealPlans = response.value else { return }
            self.menus.append(contentsOf: mealPlans.days
                                .filter { !$0.dishes.isEmpty && ($0.date.isToday || $0.date.isLaterThanOrEqual(to: Date())) }
                                .sorted { $0.date < $1.date }
                                .map {
                                    let categories = $0.dishes
                                        .sorted { $0.dishType < $1.dishType }
                                        .reduce(into: [:]) { (acc: inout [String: [Dish]], dish: Dish) -> () in
                                            let type = dish.dishType.isEmpty ? "Sonstige" : dish.dishType
                                            if acc[type] != nil {
                                                acc[type]?.append(dish)
                                            }
                                            acc[type] = [dish]
                                        }
                                        .map { CategoryViewModel(name: $0.key, dishes: $0.value) }
                
                                        print("DATE: ", $0.date)

                                        return MenuViewModel(title: formatter.string(from: $0.date), date: $0.date, categories: categories) }
                              )
        }
        
        // initiate loading of labels here, to prevent showing of placeholders
        _ = MensaEnumService.shared.getLabels()
    }
}
