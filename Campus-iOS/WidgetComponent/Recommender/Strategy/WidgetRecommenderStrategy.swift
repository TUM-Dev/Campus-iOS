//
//  WidgetRecommenderStrategy.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.07.22.
//

import Foundation

protocol WidgetRecommenderStrategy {
    func getRecommendation() async -> [WidgetRecommendation]
}
