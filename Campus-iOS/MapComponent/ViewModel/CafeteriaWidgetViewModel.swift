//
//  CafeteriaWidgetViewModel.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 25.06.22.
//

import Foundation
import MapKit
import Alamofire

@MainActor
class CafeteriaWidgetViewModel: ObservableObject {
    
    @Published var cafeteria: Cafeteria?
    @Published var menuViewModel: MenuViewModel?
    @Published var status: CafeteriaWidgetStatus
    
    private let cafeteriaService: CafeteriasServiceProtocol
    private let sessionManager = Session.defaultSession
    
    init(cafeteriaService: CafeteriasServiceProtocol) {
        self.status = .loading
        self.cafeteriaService = cafeteriaService
    }
    
    func fetch() async {
        do {
            let cafeterias = try await cafeteriaService.fetch(forcedRefresh: false)
            
            // Get the closest cafeteria.
            
            guard let location = CLLocationManager().location else {
                self.status = .error
                return
            }
            
            guard let cafeteria = cafeterias.min(
                by: {$0.coordinate.location.distance(from: location) < $1.coordinate.location.distance(from: location)}
            ) else {
                self.status = .error
                return
            }
            
            self.cafeteria = cafeteria
            
            // Get today's menu plan of the closest cafeteria, if it exists.
            
            let endpoint = EatAPI.menu(location: cafeteria.id, year: Date().year, week: Date().weekOfYear)
            sessionManager.request(endpoint).responseDecodable(of: MealPlan.self, decoder: MealPlanViewModel.decoder()) { [self] response in
                
                guard let mealPlan = response.value else {
                    self.status = .noMenu
                    return
                }
                
                guard let todaysPlan = mealPlan.days.first(where: { $0.date.day == Date().day }) else {
                    self.status = .noMenu
                    return
                }
                
                let categories = MealPlanViewModel.categories(from: todaysPlan.dishes)
                self.menuViewModel = MenuViewModel(date: todaysPlan.date, categories: categories)
                self.status = .success
            }
        } catch {
            self.status = .error
        }
    }
}

enum CafeteriaWidgetStatus {
    case success, error, loading, noMenu
}
