//
//  WidgetScreenNEW.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 20.01.23.
//
//  Based on Robyn's WidgetScreen -> uses Robyn's Recommender System an custom View Models

import SwiftUI

struct WidgetScreenNEW: View {
    
    @StateObject var model: Model
    @StateObject private var recommender: WidgetRecommender
    @StateObject var calendarWidgetVM: CalendarViewModel
    @StateObject var studyRoomWidgetVM = StudyRoomWidgetViewModel(studyRoomService: StudyRoomsService())
    @StateObject var cafeteriaWidgetVM: CafeteriaWidgetViewModel = CafeteriaWidgetViewModel(cafeteriaService: CafeteriasService())
    
    init(model: Model) {
        self._model = StateObject(wrappedValue: model)
        self._calendarWidgetVM = StateObject(wrappedValue: CalendarViewModel(model: model))
        self._recommender = StateObject(wrappedValue: WidgetRecommender(strategy: SpatioTemporalStrategy(), model: model))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("study rooms, food & calendar").titleStyle()
            ForEach(self.recommender.recommendations, id: \.id) { recommendation in
                let widget = recommendation.widget
                switch widget {
                case .cafeteria:
                    CafeteriaWidgetScreen(cafeteriaWidgetVM: self.cafeteriaWidgetVM)
                        .padding(.bottom, 10)
                case .studyRoom:
                    StudyRoomWidgetScreen(studyRoomWidgetVM: self.studyRoomWidgetVM)
                        .padding(.bottom, 10)
                case .calendar:
                    CalendarWidgetScreen(vm: self.calendarWidgetVM)
                        .padding(.bottom, 10)
                default:
                    EmptyView() //when widget isn't supposed to be shown
                }
            }
        }
        .task {
            calendarWidgetVM.fetch()
            await studyRoomWidgetVM.fetch()
            await cafeteriaWidgetVM.fetch()
            try? await recommender.fetchRecommendations()
        }
    }
}
