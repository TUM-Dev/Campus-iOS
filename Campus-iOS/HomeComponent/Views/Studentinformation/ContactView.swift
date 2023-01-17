//
//  ContactView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 30.12.22.
//

import SwiftUI

struct ContactView: View {
    
    @StateObject var model: Model
    @StateObject var profileViewModel: ProfileViewModel
    @StateObject var gradesViewModel: GradesViewModel
    @ObservedObject var personDetailedViewModel: PersonDetailedViewModel
    
    init (model: Model, profileViewModel: ProfileViewModel, gradesViewModel: GradesViewModel) {
        self._model = StateObject(wrappedValue: model)
        self._profileViewModel = StateObject(wrappedValue: profileViewModel)
        self._gradesViewModel = StateObject(wrappedValue: gradesViewModel)
        self.personDetailedViewModel = PersonDetailedViewModel(withProfile: profileViewModel.profile ?? ProfileViewModel.defaultProfile)
        self.personDetailedViewModel.fetch()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("student information").titleStyle()
            
            ContactCardView(profileViewModel: self.profileViewModel, gradesViewModel: self.gradesViewModel, personDetailedViewModel: self.personDetailedViewModel)
                .padding(.bottom, 10)
            
            TuitionViewNEW(model: self.model, profileViewModel: self.profileViewModel)
                .padding(.bottom, 10)
            
            LinkView()
            
        }
    }
}
