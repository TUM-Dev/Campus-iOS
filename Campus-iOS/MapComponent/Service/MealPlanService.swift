//
//  MealPlanService.swift
//  Campus-iOS
//
//  Created by David Lin on 10.02.23.
//

import Foundation

struct MealPlanService {
    func fetch(cafeteria: Cafeteria, forcedRefresh: Bool) async throws -> [cafeteriaMenu] {
        let thisWeekAPI = EatAPI.menu(location: cafeteria.id, year: Date().year, week: Date().weekOfYear)
       
        let thisWeekMealPlanResponse = try await fetch(menu: thisWeekAPI, forcedRefresh: forcedRefresh)
        
        let thisWeekMenu: [cafeteriaMenu] = getMenuPerDay(mealPlan: thisWeekMealPlanResponse)
        
        guard let nextWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) else {
            return thisWeekMenu
        }
        let nextWeekAPI = EatAPI.menu(location: cafeteria.id, year: nextWeek.year, week: nextWeek.weekOfYear)
        
        var menus = thisWeekMenu
        
        do {
            let nextWeekMealPlanResponse = try await fetch(menu: nextWeekAPI, forcedRefresh: forcedRefresh)
            
            let nextWeekMenu = getMenuPerDay(mealPlan: nextWeekMealPlanResponse)
            
            menus = menus + nextWeekMenu.filter{ menu in !thisWeekMenu.contains(where: {$0.date == menu.date}) } // don't re-add already existent days
        } catch {
            //Throw no error, since sometimes the next weeks menu isn't ready yet, thus a 404 error is thrown, but at the end of the week the next week's menu is ready.
            print(error)
        }
        
        return menus
    }
    
    func fetch(menu: EatAPI, forcedRefresh: Bool) async throws -> MealPlan {
        let response: MealPlan = try await MainAPI.makeRequest(endpoint: menu, forcedRefresh: forcedRefresh)
        
        return response
    }
    
    
    
    func getMenuPerDay(mealPlan: MealPlan) -> [cafeteriaMenu] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var menus = [cafeteriaMenu]()
        menus = mealPlan.days
            .filter { !$0.dishes.isEmpty && ($0.date.isToday || $0.date.isLaterThanOrEqual(to: Date())) }
            .sorted { $0.date < $1.date }
            .map {
                let categories = categories(from: $0.dishes)
                return cafeteriaMenu(date: $0.date, categories: categories)
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
