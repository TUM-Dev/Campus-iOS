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
    @StateObject var gradesViewModel: GradesViewModel
    @StateObject var profileVm: ProfileViewModel
    
    init (model: Model) {
        self._model = StateObject(wrappedValue: model)
        self._gradesViewModel = StateObject(wrappedValue: GradesViewModel(model: model, service: GradesService()))
        self._profileVm = StateObject(wrappedValue: ProfileViewModel(model: model, service: ProfileService()))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if case .success(let profile) = profileVm.profileState {
                ContactCardView(model: self.model, profile: profile, profileVm: self.profileVm, gradesVm: self.gradesViewModel)
                    .padding(.bottom, 10)
            }
            
            TuitionScreen(vm: self.profileVm)
                .padding(.bottom, 10)
            
            LinkView()
            
        }.task {
            await gradesViewModel.getGrades(forcedRefresh: true)
            await profileVm.getProfile(forcedRefresh: true)
        }
    }
}
