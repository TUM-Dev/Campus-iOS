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
    @Published var menu: cafeteriaMenu?
    @Published var status: CafeteriaWidgetStatus = .loading
    
    private let cafeteriaService: CafeteriasService
    
    private let locationManager = CLLocationManager()
    
    init(cafeteriaService: CafeteriasService) {
        self.cafeteriaService = cafeteriaService
        
        let authorization = locationManager.authorizationStatus
        if authorization != .authorizedWhenInUse || authorization != .authorizedAlways {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func fetch() async {
        do {
            let cafeterias = try await cafeteriaService.fetch(forcedRefresh: true)
            
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
            
            let menus = try await MealPlanService().fetch(cafeteria: cafeteria, forcedRefresh: false)
            self.menu = menus.first
            self.status = .success
    
        } catch {
            self.status = .error
        }
    }
}

enum CafeteriaWidgetStatus {
    case success, error, loading, noMenu
}
