//
//  HomeView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 28.12.22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var model: Model
    @StateObject var profileViewModel = ProfileViewModel()
    
    var body: some View {
        ScrollView{
            ContactView(profileViewModel: profileViewModel)
            WidgetScreen(model: model)
        }
        .task {
            profileViewModel.fetch()
        }
        .background(Color.primaryBackground)
        .padding(.top, 50)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(model: MockModel())
    }
}
