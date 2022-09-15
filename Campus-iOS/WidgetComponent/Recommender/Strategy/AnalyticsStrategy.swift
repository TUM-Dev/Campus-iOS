//
//  AnalyticsStrategy.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 17.08.22.
//

import Foundation
import CoreData

struct AnalyticsStrategy: WidgetRecommenderStrategy {
        
    func getRecommendation() async -> [WidgetRecommendation] {
        let scores = multinominalLogisticRegression(data: getData())
        return []
    }
    
    private func getData() -> [AppUsageDataEntity] {
        let request = AppUsageDataEntity.fetchRequest()
        let results = try? PersistenceController.shared.container.viewContext.fetch(request)
        
        return results ?? []
    }
    
    private func multinominalLogisticRegression(data: [AppUsageDataEntity]) -> [Float] {
        return softMax(regressionModel(for: data))
    }
    
    // Applies weights to the input vector.
    private func regressionModel(for data: [AppUsageDataEntity]) -> [Float] {
        return Widget.allCases.map{ score($0, data: data) }
    }
    
    // https://en.wikipedia.org/wiki/Softmax_function
    private func softMax(_ x: [Float]) -> [Float] {
        
        var result: [Float] = []
        
        for x_i in x {
            let result_i = exp(x_i) / x.reduce(0, { $0 + exp($1) })
            result.append(result_i)
        }
        
        return result
    }
    
    // The following aspects contribute to the score of the widget:
    //   (1) The number of times the user has opened a view associated to the widget.
    //   (2) The user's current distance to any of the stored locations for these views.
    //   (3) The current date compared to any of the stored dates for these views.
    private func score(_ widget: Widget, data: [AppUsageDataEntity]) -> Float {
                
        let associatedViews: [String] = widget.associatedViews().map{ $0.rawValue }
        
        // Stored data that are relevant to the given widget, e.g. the cafeteria view is related to the cafeteria widget.
        let associatedData = data.filter { entry in
            if let view = entry.view {
                return associatedViews.contains(view)
            }
            
            return false
        }
        
        /* (1) */
        let score = Float(associatedData.count) / Float(max(data.count, 1))
        
        /* TODO: (2) */
        
        /* TODO: (3) */
        
        return score
    }
    
}
