//
//  WidgetScreenNEW.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 20.01.23.
//

import SwiftUI

struct WidgetScreenNEW: View {
    
    @StateObject var model: Model
    @StateObject var calendarWidgetVM: CalendarViewModel
    @StateObject var studyRoomWidgetVM = StudyRoomWidgetViewModel(studyRoomService: StudyRoomsService())
    @StateObject var cafeteriaWidgetVM: CafeteriaWidgetViewModel = CafeteriaWidgetViewModel(cafeteriaService: CafeteriasService())
    
    init(model: Model) {
        self._model = StateObject(wrappedValue: model)
        self._calendarWidgetVM = StateObject(wrappedValue: CalendarViewModel(model: model))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("study rooms, food & calendar").titleStyle()
            CalendarWidgetScreen(vm: self.calendarWidgetVM)
                .padding(.bottom, 10)
            StudyRoomWidgetScreen(studyRoomWidgetVM: self.studyRoomWidgetVM)
                .padding(.bottom, 10)
            CafeteriaWidgetScreen(cafeteriaWidgetVM: self.cafeteriaWidgetVM)
        }
        .task {
            print("")
            calendarWidgetVM.fetch()
            await studyRoomWidgetVM.fetch()
            await cafeteriaWidgetVM.fetch()
        }
    }
}
