//
//  CafeteriaWidgetScreen.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 08.02.23.
//

import SwiftUI

struct CafeteriaWidgetScreen: View {
    
    @StateObject var viewModel: CafeteriaWidgetViewModel = CafeteriaWidgetViewModel(cafeteriaService: CafeteriasService())
    
    var body: some View {
        Group {
            switch(viewModel.status) {
            case .error:
                EmptyView() //muss mann noch besser handeln -> keine cafeterias nearby
            case .loading:
                WidgetLoadingView(text: "Searching nearby cafeteria")
            default:
                if let cafeteria = viewModel.cafeteria {
                    CafeteriaWidget2(cafeteriaWidgetVM: self.viewModel, dishes: viewModel.menu?.getDishes() ?? [])
                } else {
                    TextWidgetView(text: "There was an error getting the menu from the nearest cafeteria.")
                }
            }
        }.task {
            await viewModel.fetch()
        }
    }
}
