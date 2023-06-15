//
//  HomeView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 28.12.22.
//

import SwiftUI

@available(iOS 16.0, *)
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
            WidgetScreen(model: self.model)
            /*WidgetScreenOld(model: self.model)
             .padding(.bottom, 25)*/ //Robyn's WidgetScreen
        }
        .padding(.top, 50)
        .background(Color.primaryBackground)
    }
}

@available(iOS 16.0, *)
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(model: MockModel())
    }
}
