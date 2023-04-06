//
//  DishService.swift
//  Campus-iOS
//
//  Created by David Lin on 23.01.23.
//

import Foundation

struct DishService {
    func fetch(forcedRefresh: Bool) async -> [String: DishLabel]? {
        do {
            let response: [DishLabel] = try await MainAPI.makeRequest(endpoint: EatAPI.labels, forcedRefresh: forcedRefresh)
            var labels = [String: DishLabel]()
            for dishLabel in response {
                labels[dishLabel.name] = dishLabel
            }
            
            return labels
        } catch {
            print(error)
            return nil
            // No error is thrown, since the labels, can still be displayed, but just as text, instead of an emoji.
        }
    }
}
