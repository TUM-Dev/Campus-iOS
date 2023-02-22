//
//  HomeView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 28.12.22.
//

import SwiftUI

struct HomeScreen: View {
    
    @StateObject var model: Model
    
    var body: some View {
        ScrollView{
            ContactScreen(model: self.model)
                .padding(.top, 15)
                .padding(.bottom, 10)
            Divider()
                .padding(.horizontal)
                .padding(.bottom, 10)
            WidgetScreenNEW(model: self.model)
            /*WidgetScreen(model: self.model)
                .padding(.bottom, 25)*/ //Robyn's WidgetScreen
            MoviesViewNEW()
                .padding(.bottom)
            NewsViewNEW(viewModel: NewsViewModel())
                .padding(.bottom, 25)
        }
        .padding(.top, 50)
        .background(Color.primaryBackground)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(model: MockModel())
    }
}
