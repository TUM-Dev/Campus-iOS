//
//  ProfileToolbarGroup.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 11.12.21.
//

import SwiftUI

struct ProfileToolbar: View {
    @ObservedObject var profileModel: ProfileModel
    
    var body: some View {
        
        Button(action: {profileModel.showProfile.toggle()}) {
            Image(systemName: "person.crop.circle")
        }
        .sheet(isPresented: $profileModel.showProfile) {
            ProfileView()
                .environmentObject(profileModel)
        }
        
    }
}

struct ProfileToolbarGroup_Previews: PreviewProvider {
    static var previews: some View {
        ProfileToolbar(profileModel: ProfileModel())
    }
}
