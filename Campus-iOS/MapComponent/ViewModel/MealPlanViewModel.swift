//
//  File.swift
//  Campus-iOS
//
//  Created by Tim Gymnich on 19.01.22.
//

import Foundation
import SwiftUI
import Alamofire

@MainActor
class MealPlanViewModel: ObservableObject {
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
            let data = try await service.fetch(cafeteria: self.cafeteria, forcedRefresh: forcedRefresh)
            print(data)
            self.state = .success(
                data: data
            )
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
    
}
