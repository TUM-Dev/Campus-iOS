//
//  HomeView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 28.12.22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var model: Model = Model()
    
    var body: some View {
        ScrollView{
            WidgetScreen(model: model)
        }
        .background(Color.primaryBackground)
        .padding(.top, 50)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
