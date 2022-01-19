//
//  ProfileToolbarGroup.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 11.12.21.
//

import SwiftUI

struct ProfileToolbar: View {
    @ObservedObject var model: Model
    
    var body: some View {
        
        Button(action: {model.showProfile.toggle()}) {
            Image(systemName: "person.crop.circle")
        }
        .sheet(isPresented: $model.showProfile) {
            ProfileView(model: model)
        }
        
    }
}

struct ProfileToolbarGroup_Previews: PreviewProvider {
    static var previews: some View {
        ProfileToolbar(model: Model())
    }
}
