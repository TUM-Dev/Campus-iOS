//
//  WidgetRecommender.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.07.22.
//

import Foundation
import SwiftUI

class WidgetRecommender {
        
    private let strategy: WidgetRecommenderStrategy
    private let model: Model
    
    init(strategy: WidgetRecommenderStrategy, model: Model) {
        self.strategy = strategy
        self.model = model
    }
    
    func getRecommendation() -> [WidgetRecommendation] {
        return strategy.getRecommendation().sorted(by: { $0.priority > $1.priority })
    }
    
    @ViewBuilder
    func getWidget(for widget: Widget, size: WidgetSize) -> some View {
        switch widget {
        case .cafeteria:
            CafeteriaWidgetView(size: size)
        case .studyRoom:
            StudyRoomWidgetView(size: size)
        case .calendar:
            CalendarWidgetView(size: size)
        case .tuition:
            TuitionWidgetView(size: TuitionWidgetSize.from(widgetSize: size))
        case .grades:
            GradeWidgetView(model: model, size: size)
        }
    }
}
