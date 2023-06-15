//
//  CafeteriaWidgetScreen.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 08.02.23.
//

import SwiftUI

struct CafeteriaWidgetScreen: View {
    
    @StateObject var viewModel: CafeteriaWidgetViewModel
    
    var body: some View {
        Group {
            switch(viewModel.status) {
            case .error:
                EmptyView() // -> keine cafeterias nearby
            case .loading:
                LoadingView(text: "Searching nearby cafeteria")
            default:
                CafeteriaWidget(cafeteriaWidgetVM: self.viewModel, dishes: viewModel.menu?.getDishes() ?? [])
            }
        }
    }
}
