//
//  ProfileTuitionNavigationLink.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.02.22.
//

import SwiftUI

struct ProfileMyTumSection: View {
    
    @EnvironmentObject private var model: Model
    
    var formattedAmount: String {
        guard let amount = self.model.profile.tuition?.amount else {
            return "n/a"
        }
        return OpenTuitionAmountView.currencyFormatter.string(from: amount) ?? "n/a"
    }
    
    var body: some View {
        Section("MY TUM") {
            NavigationLink(destination: TuitionView(viewModel: self.model.profile).navigationBarTitle(Text("Tuition fees"))) {
                Label {
                    HStack {
                        Text("Tuition fees")
                        if let isOpenAmount = self.model.profile.tuition?.isOpenAmount, isOpenAmount != true {
                            Spacer()
                            Text("✅")
                        } else {
                            Spacer()
                            Text(self.formattedAmount).foregroundColor(.red)
                        }
                    }
                } icon: {
                    Image(systemName: "eurosign.circle")
                }
            }
            .disabled(!self.model.isUserAuthenticated)
            
            NavigationLink(destination: PersonSearchView().navigationBarTitle(Text("Person Search")).navigationBarTitleDisplayMode(.large)) {
                Label("Person Search", systemImage: "magnifyingglass")
            }
            .disabled(!self.model.isUserAuthenticated)
            
            NavigationLink(destination: LectureSearchView(model: model).navigationBarTitle(Text("Lecture Search")).navigationBarTitleDisplayMode(.large)) {
                Label("Lecture Search", systemImage: "brain.head.profile")
            }
            .disabled(!self.model.isUserAuthenticated)
        }
    }
}

struct ProfileMyTumSection_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMyTumSection()
    }
}
