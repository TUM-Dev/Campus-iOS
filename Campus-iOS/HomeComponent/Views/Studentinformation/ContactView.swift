//
//  ContactView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 30.12.22.
//

import SwiftUI

struct ContactView: View {
    @StateObject var profileViewModel: ProfileViewModel
    @StateObject var gradesViewModel: GradesViewModel
    @ObservedObject var personDetailedViewModel: PersonDetailedViewModel
    
    init (profileViewModel: ProfileViewModel, gradesViewModel: GradesViewModel) {
        self._profileViewModel = StateObject(wrappedValue: profileViewModel)
        self._gradesViewModel = StateObject(wrappedValue: gradesViewModel)
        self.personDetailedViewModel = PersonDetailedViewModel(withProfile: profileViewModel.profile ?? ProfileViewModel.defaultProfile)
        self.personDetailedViewModel.fetch()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Studentinformation")
                    .font(.headline.bold())
                    .textCase(.uppercase)
                    .foregroundColor(Color("tumBlue"))
                Spacer()
            }
            .padding(.leading, 40)
            .padding(.bottom, 5)
            
            ContactCardView(profileViewModel: self.profileViewModel, gradesViewModel: self.gradesViewModel, personDetailedViewModel: self.personDetailedViewModel)
                .padding(.bottom, 10)
            
            TuitionViewNEW(profileViewModel: self.profileViewModel)
                .padding(.bottom, 10)
            
            LinkView()
            
        }
        .padding(.bottom)
    }
}
