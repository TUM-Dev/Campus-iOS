//
//  MockLocationStrategy.swift
//  Campus-iOSTests
//
//  Created by Robyn Kölle on 07.11.22.
//

import Foundation

@testable import Campus_iOS

struct MockLocationStrategy: WidgetRecommenderStrategy {
    
    private let recommendations: [WidgetRecommendation]
    
    init(recommendations: [WidgetRecommendation]) {
        self.recommendations = recommendations
    }
    
    func getRecommendation() async throws -> [WidgetRecommendation] {
        return recommendations
    }
}
