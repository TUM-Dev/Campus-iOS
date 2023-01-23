//
//  File.swift
//  Campus-iOS
//
//  Created by Tim Gymnich on 19.01.22.
//

import Foundation
import SwiftUI
import Alamofire

struct MealPlanService {
    func fetch(cafeteria: Cafeteria, forcedRefresh: Bool) async throws -> [Menu] {
        let thisWeekAPI = EatAPI2.menu(location: cafeteria.id, year: Date().year, week: Date().weekOfYear)
       
        let thisWeekMealPlanResponse = try await fetch(menu: thisWeekAPI, forcedRefresh: forcedRefresh)
        
        let thisWeekMenu: [Menu] = getMenuPerDay(mealPlan: thisWeekMealPlanResponse)
        
        guard let nextWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) else {
            return thisWeekMenu
        }
        let nextWeekAPI = EatAPI2.menu(location: cafeteria.id, year: nextWeek.year, week: nextWeek.weekOfYear)
        
        let nextWeekMealPlanResponse = try await fetch(menu: nextWeekAPI, forcedRefresh: forcedRefresh)
        
        let nextWeekMenu = getMenuPerDay(mealPlan: nextWeekMealPlanResponse)

        let menus = thisWeekMenu + nextWeekMenu.filter{ menu in !thisWeekMenu.contains(where: {$0.date == menu.date}) } // don't re-add already existent days
        
        print(menus)
        print("Response MEALPLAN")
        
        return menus
    }
    
    func fetch(menu: EatAPI2, forcedRefresh: Bool) async throws -> MealPlan {
        let response: MealPlan = try await MainAPI.makeRequest(endpoint: menu, forcedRefresh: forcedRefresh)
        
        return response
    }
    
    func getMenuPerDay(mealPlan: MealPlan) -> [Menu] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var menus = [Menu]()
        menus = mealPlan.days
            .filter { !$0.dishes.isEmpty && ($0.date.isToday || $0.date.isLaterThanOrEqual(to: Date())) }
            .sorted { $0.date < $1.date }
            .map {
                let categories = categories(from: $0.dishes)
                return Menu(date: $0.date, categories: categories)
            }
        
        return menus.sorted { $0.date < $1.date }
    }
    
    func categories(from dishes: [Dish]) -> [MenuCategory] {
        return dishes
            .sorted { $0.dishType < $1.dishType }
            .reduce(into: [:]) { (acc: inout [String: [Dish]], dish: Dish) -> () in
                let type = dish.dishType.isEmpty ? "Sonstige" : dish.dishType
                if acc[type] != nil {
                    acc[type]?.append(dish)
                }
                acc[type] = [dish]
            }
            .map { MenuCategory(name: $0.key, dishes: $0.value) }
    }
}

@MainActor
class MealPlanViewModel2: ObservableObject {
    @Published var state: APIState<[Menu]> = .na
    @Published var hasError: Bool = false
    
    let service = MealPlanService()
    let cafeteria: Cafeteria
    
    init(cafeteria: Cafeteria) {
        self.cafeteria = cafeteria
    }
    
    func getMenus(forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.state = .loading
        }
        self.hasError = false

        do {
            self.state = .success(
                data: try await service.fetch(cafeteria: self.cafeteria, forcedRefresh: forcedRefresh)
            )
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
    
}

//final class MealPlanViewModel: ObservableObject {
//    private let cafeteria: Cafeteria
//    private let endpoint = EatAPI.canteens
//    private let sessionManager = Session.defaultSession
//    
//    @Published private(set) var title: String
//    @Published private(set) var menus: [MenuViewModel] = []
//    @Published var selectedMenu: MenuViewModel?
//    
//    init(cafeteria: Cafeteria) {
//        self.cafeteria = cafeteria
//        self.title = cafeteria.name
//        
//        fetch()
//    }
//    
//    func fetch() {
//        let thisWeekEndpoint = EatAPI.menu(location: cafeteria.id, year: Date().year, week: Date().weekOfYear)
//        
//        sessionManager.request(thisWeekEndpoint).responseDecodable(of: MealPlan.self, decoder: MealPlanViewModel.decoder()) { [self] response in
//            guard let mealPlans = response.value else { return }
//            addMealPlans(mealPlans: mealPlans)
//            if self.menus.count > 0 {
//                selectedMenu = self.menus[0]
//            }
//        }
//        
//        guard let nextWeek =  Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) else { return }
//        
//        let nextWeekEndpoint = EatAPI.menu(location: cafeteria.id, year: nextWeek.year, week: nextWeek.weekOfYear)
//        
//        sessionManager.request(nextWeekEndpoint).responseDecodable(of: MealPlan.self, decoder: MealPlanViewModel.decoder()) { [self] response in
//            guard let mealPlans = response.value else { return }
//            addMealPlans(mealPlans: mealPlans)
//        }
//        
//        // initiate loading of labels here, to prevent showing of placeholders
//        _ = MensaEnumService.shared.getLabels()
//    }
//    
//    func addMealPlans(mealPlans: MealPlan){
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        
//        self.menus.append(contentsOf: mealPlans.days
//            .filter { !$0.dishes.isEmpty && ($0.date.isToday || $0.date.isLaterThanOrEqual(to: Date())) }
//            .sorted { $0.date < $1.date }
//            .map {
//                let categories = MealPlanViewModel.categories(from: $0.dishes)
//                return MenuViewModel(date: $0.date, categories: categories) }
//            .filter{ menu in !self.menus.contains(where: {$0.date == menu.date}) } // don't re-add already existent days
//        )
//        
//        self.menus = self.menus.sorted { $0.date < $1.date }
//    }
//    
//    static func categories(from dishes: [Dish]) -> [MenuCategory] {
//        return dishes
//            .sorted { $0.dishType < $1.dishType }
//            .reduce(into: [:]) { (acc: inout [String: [Dish]], dish: Dish) -> () in
//                let type = dish.dishType.isEmpty ? "Sonstige" : dish.dishType
//                if acc[type] != nil {
//                    acc[type]?.append(dish)
//                }
//                acc[type] = [dish]
//            }
//            .map { MenuCategory(name: $0.key, dishes: $0.value) }
//    }
//    
//    static func decoder() -> JSONDecoder {
//        let decoder = JSONDecoder()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        decoder.dateDecodingStrategy = .formatted(formatter)
//        
//        return decoder
//    }
//}
