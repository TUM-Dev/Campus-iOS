//
//  ContactView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 30.12.22.
//

import SwiftUI

@available(iOS 16.0, *)
struct ContactScreen: View {
    
    @StateObject var model: Model
    @StateObject var gradesViewModel: GradesViewModel //provides studyprogram info
    @StateObject var profileVm: ProfileViewModel
    let profile: Profile
    
    init (model: Model, profileVm: ProfileViewModel, profile: Profile) {
        self._model = StateObject(wrappedValue: model)
        self._gradesViewModel = StateObject(wrappedValue: GradesViewModel(model: model, service: GradesService()))
        self._profileVm = StateObject(wrappedValue: profileVm)
        self.profile =  profile
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ContactCardView(model: self.model, profile: profile, profileVm: self.profileVm, gradesVm: self.gradesViewModel)
                .padding(.bottom, 10)
            
            
            TuitionScreen(vm: self.profileVm)
                .padding(.bottom, 10)
            
            LinkView()
            
        }.task {
            await gradesViewModel.getGrades(forcedRefresh: true)
        }
    }
}
