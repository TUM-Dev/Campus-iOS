//
//  SpatioTemporalStrategy.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 02.08.22.
//

import Foundation

struct SpatioTemporalStrategy: WidgetRecommenderStrategy {
    
    func getRecommendation() async -> [WidgetRecommendation] {
        let timeStrategy = TimeStrategy()
        let locationStrategy = LocationStrategy()
        
        let timeRecommendations = await timeStrategy.getRecommendation()
        let locationRecommendations = await locationStrategy.getRecommendation()
        
        let recommendations = Widget.allCases.map {
            WidgetRecommendation(
                widget: $0,
                priority: priority(for: $0, in: timeRecommendations) + priority(for: $0, in: locationRecommendations)
            )
        }
        
        return recommendations.filter { $0.priority > 0 }
    }
    
    private func priority(for widget: Widget, in array: [WidgetRecommendation]) -> Int {
        return array.first(where: { $0.widget == widget } )?.priority ?? 0
    }
}
