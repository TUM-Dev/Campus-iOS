//
//  WidgetRecommender.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.07.22.
//

import Foundation
import SwiftUI

@MainActor
class WidgetRecommender: ObservableObject {
    
    @Published var status: WidgetRecommenderStatus
    @Published var recommendations: [WidgetRecommendation]
        
    private let strategy: WidgetRecommenderStrategy
    private let model: Model

    init(strategy: WidgetRecommenderStrategy, model: Model) {
        self.strategy = strategy
        self.model = model
        self.status = .loading
        self.recommendations = []
    }
    
    func fetchRecommendations() async {
        self.recommendations = await strategy.getRecommendation().sorted(by: { $0.priority > $1.priority })
        self.status = .success
    }
    
    @ViewBuilder
    func getWidget(for widget: Widget, size: WidgetSize) -> some View {
        switch widget {
        case .cafeteria:
            CafeteriaWidgetView(size: size)
        case .studyRoom:
            StudyRoomWidgetView(size: size)
        case .calendar:
            CalendarWidgetView(model: model, size: size)
        case .tuition:
            TuitionWidgetView(size: TuitionWidgetSize.from(widgetSize: size))
        case .grades:
            GradeWidgetView(model: model, size: size)
        }
    }
}

enum WidgetRecommenderStatus {
    case loading, success
}
