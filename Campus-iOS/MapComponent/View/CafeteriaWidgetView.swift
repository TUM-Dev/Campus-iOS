//
//  CafeteriaWidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI
import MapKit

struct CafeteriaWidgetView: View {
    
    @StateObject var viewModel: CafeteriaWidgetViewModel
    
    var body: some View {
        
        VStack {
            switch(viewModel.status) {
            case .error:
                Text("No nearby cafeteria.")
            case .loading:
                Text("Searching nearby cafeteria")
                ProgressView()
            default:
                if let cafeteria = viewModel.cafeteria {
                    Text(cafeteria.title ?? "Unknown cafeteria")
                        .bold()
                }
                
                if viewModel.status != .noMenu, let menuVm = viewModel.menuViewModel {
                    MenuView(viewModel: menuVm)
                } else {
                    Spacer()
                    Text("No menu for today.")
                    Spacer()
                }
            }
        }
        .task {
            await viewModel.fetch()
        }
    }
}

struct CafeteriaWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CafeteriaWidgetView(viewModel: CafeteriaWidgetViewModel(cafeteriaService: CafeteriasService()))
        CafeteriaWidgetView(viewModel: CafeteriaWidgetViewModel(cafeteriaService: CafeteriasService()))
            .preferredColorScheme(.dark)
    }
}
