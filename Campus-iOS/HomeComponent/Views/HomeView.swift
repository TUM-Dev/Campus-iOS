//
//  HomeView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 28.12.22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var model: Model
    @StateObject var profileViewModel = ProfileViewModel()
    @StateObject var gradesViewModel: GradesViewModel
    @StateObject var calendarViewModel: CalendarViewModel
    
    init(model: Model) {
        self._model = StateObject(wrappedValue: model)
        self._gradesViewModel = StateObject(wrappedValue: GradesViewModel(model: model, service: GradesService()))
        self._calendarViewModel = StateObject(wrappedValue: CalendarViewModel(model: model))
    }
    
    var body: some View {
        ScrollView{
            ContactView(model: self.model, profileViewModel: self.profileViewModel, gradesViewModel: self.gradesViewModel)
                .padding(.top, 15)
                .padding(.bottom)
            WidgetScreenNEW(model: self.model)
                .padding(.bottom)
            /*WidgetScreen(model: self.model)
                .padding(.bottom)*/
            MoviesViewNEW()
                .padding(.bottom)
        }
        .task {
            calendarViewModel.fetch()
            profileViewModel.fetch()
            await gradesViewModel.getGrades()
        }
        .padding(.top, 50)
        .background(Color.primaryBackground)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(model: MockModel())
    }
}
