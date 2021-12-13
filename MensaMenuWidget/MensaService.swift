//
//  MensaService.swift
//  TUM Campus App
//
//  Created by Nikolai Madlener on 12.12.21.
//  Copyright © 2021 TUM. All rights reserved.
//

import Foundation

final class MensaService {
    static let shared = MensaService()

    private init() {}
    
    public func getMensaMenu(mensaApiKey: String) async throws -> Menu? {
        let url = URL(string: "https://tum-dev.github.io/eat-api/" + "\(mensaApiKey)/\(Date().year)/\(Date().weekOfYear).json")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        print(data)
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter.yyyyMMdd
        decoder.dateDecodingStrategy = .formatted(formatter)

        do {
            let mealPlan = try decoder.decode(MealPlan.self, from: data)
            return mealPlan.days.first(where: {
                !$0.dishes.isEmpty && ($0.date?.isToday ?? false || $0.date?.isLaterThanOrEqual(to: Date()) ?? false)
            })
        } catch {
            print(error)
        }
        return nil
    }
}
