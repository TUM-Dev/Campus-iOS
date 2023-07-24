//
//  WidgetScreen.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 20.01.23.
//
//  Based on Robyn's WidgetScreen -> uses Robyn's Recommender System and custom View Models
//  Individual Widgets can be found in their respective components

import SwiftUI

struct WidgetScreen: View {
    
    @StateObject var model: Model
    @StateObject private var recommender: WidgetRecommender
    @StateObject var calendarWidgetVM: CalendarViewModel
    @StateObject var studyRoomWidgetVM = StudyRoomWidgetViewModel(studyRoomService: StudyRoomsService())
    @StateObject var cafeteriaWidgetVM = CafeteriaWidgetViewModel(cafeteriaService: CafeteriasService())
    @StateObject var departuresWidgetVM: DeparturesWidgetViewModel = DeparturesWidgetViewModel()
    
    init(model: Model) {
        self._model = StateObject(wrappedValue: model)
        self._calendarWidgetVM = StateObject(wrappedValue: CalendarViewModel(model: model, service: CalendarService()))
        self._recommender = StateObject(wrappedValue: WidgetRecommender(strategy: SpatioTemporalStrategy(), model: model))
    }
    
    var body: some View {
        VStack {
            //dynamic widgets
            ForEach(self.recommender.recommendations, id: \.id) { recommendation in
                let widget = recommendation.widget
                switch widget {
                case .cafeteria:
                    CafeteriaWidgetScreen(viewModel: self.cafeteriaWidgetVM)
                        .padding(.bottom)
                case .studyRoom:
                    StudyRoomWidgetScreen(studyRoomWidgetVM: self.studyRoomWidgetVM)
                        .padding(.bottom)
                case .calendar:
                    CalendarWidgetScreen(vm: self.calendarWidgetVM)
                        .padding(.bottom)
                case .departures:
                    DeparturesWidgetScreen(departuresViewModel: self.departuresWidgetVM)
                        .padding(.bottom)
                default:
                    EmptyView() //when widget isn't supposed to be shown
                }
            }
            //static widgets
            MoviesScreen(isWidget: true)

            NewsScreen(isWidget: true)
                .padding(.bottom)
        }
        .task {
            await calendarWidgetVM.getCalendar(forcedRefresh: true)
            await studyRoomWidgetVM.fetch()
            await cafeteriaWidgetVM.fetch()
            try? await recommender.fetchRecommendations()
        }
    }
}
