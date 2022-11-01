//
//  WidgetRecommender.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.07.22.
//

import Foundation
import SwiftUI
import CoreData

@MainActor
class WidgetRecommender: ObservableObject {
    
    @Published var status: WidgetRecommenderStatus
    @Published var recommendations: [WidgetRecommendation]
        
    private let strategy: WidgetRecommenderStrategy
    private let model: Model
    private let context: NSManagedObjectContext

    init(strategy: WidgetRecommenderStrategy, model: Model, context: NSManagedObjectContext) {
        self.strategy = strategy
        self.model = model
        self.context = context
        self.status = .loading
        self.recommendations = []
    }
    
    func fetchRecommendations() async throws {
        let recommendations = try await strategy.getRecommendation().sorted(by: { $0.priority > $1.priority })
        self.recommendations = recommendations
        self.status = .success
    }
    
    @ViewBuilder
    func getWidget(for widget: Widget, size: WidgetSize, refresh: Binding<Bool> = .constant(false)) -> some View {
        switch widget {
        case .cafeteria:
            CafeteriaWidgetView(size: size, refresh: refresh)
        case .studyRoom:
            StudyRoomWidgetView(size: size, refresh: refresh)
        case .calendar:
            CalendarWidgetView(model: model, size: size, refresh: refresh)
        case .tuition:
            TuitionWidgetView(size: TuitionWidgetSize.from(widgetSize: size), refresh: refresh)
        case .grades:
            GradeWidgetView(context: context, model: model, size: size, refresh: refresh)
        }
    }
}

enum WidgetRecommenderStatus {
    case loading, success
}
