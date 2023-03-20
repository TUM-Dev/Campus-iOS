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
    @StateObject var profileViewModel = ProfileViewModel()
    @StateObject var gradesViewModel: GradesViewModel
    
    init (model: Model) {
        self._model = StateObject(wrappedValue: model)
        self._gradesViewModel = StateObject(wrappedValue: GradesViewModel(model: model, service: GradesService()))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ContactCardView(profileViewModel: self.profileViewModel, gradesViewModel: self.gradesViewModel, personDetailedViewModel: PersonDetailedViewModel(withProfile: self.profileViewModel.profile ?? ProfileViewModel.defaultProfile))
                .padding(.bottom, 10)
            
            TuitionViewNEW(model: self.model, profileViewModel: self.profileViewModel)
                .padding(.bottom, 10)
            
            LinkView()
            
        }.task {
            profileViewModel.fetch()
            await gradesViewModel.getGrades()
        }
    }
}
