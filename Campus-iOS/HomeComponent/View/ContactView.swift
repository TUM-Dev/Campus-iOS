//
//  ContactView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 30.12.22.
//

import SwiftUI

struct ContactView: View {
    @StateObject var profileViewModel: ProfileViewModel
    @ObservedObject var personDetailedViewModel: PersonDetailedViewModel
    
    init (profileViewModel: ProfileViewModel) {
        self._profileViewModel = StateObject(wrappedValue: profileViewModel
                                            )
        self.personDetailedViewModel = PersonDetailedViewModel(withProfile: profileViewModel.profile ?? ProfileViewModel.defaultProfile)
        self.personDetailedViewModel.fetch()
    }
    
    var body: some View {
        Group {
            if let profile = self.profileViewModel.profile,
               let profileImage = self.profileViewModel.profileImage {
                if profile.firstname != nil {
                    Text("Hi, " + profile.firstname!).font(.largeTitle).bold().frame(width: 350, height: 50, alignment: .leading)
                } else {
                    Text("Welcome").font(.largeTitle).bold().frame(width: 350, height: 50, alignment: .leading)
                }
                HStack {
                    profileImage
                        .resizable()
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color(.secondaryLabel))
                    
                    VStack(alignment: .leading) {
                        Text(profile.fullName)
                            .font(.title2)
                        Text(profile.tumID!)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(personDetailedViewModel.person?.email ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
                .frame(width: UIScreen.main.bounds.size.width * 0.9)
                .background(Color.secondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
                .padding(.bottom)
            } else {
                ProgressView()
            }
        }
    }
}
