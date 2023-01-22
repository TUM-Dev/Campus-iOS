//
//  ProfileToolbarGroup.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 11.12.21.
//

import SwiftUI

struct ProfileToolbar: View {
    @StateObject var model: Model
    @State var showProfile = false
    
    var body: some View {
        
        Button(action: {self.showProfile.toggle()}) {
            Image(systemName: "person.crop.circle")
        }
        .sheet(isPresented: $showProfile) {
            ProfileView2(model: model)
        }
        
    }
}

struct ProfileToolbarGroup_Previews: PreviewProvider {
    static var previews: some View {
        ProfileToolbar(model: Model())
    }
}
