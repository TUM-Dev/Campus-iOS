//
//  MapView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 16.12.21.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        ZStack {
            MapContent(
                zoomOnUser: $viewModel.zoomOnUser,
                panelPosition: $viewModel.panelPosition,
                canteens: $viewModel.canteens,
                selectedCanteen: $viewModel.selectedCanteen)
            Panel(zoomOnUser: $viewModel.zoomOnUser,
                  panelPosition: $viewModel.panelPosition,
                  lockPanel: $viewModel.lockPanel,
                  canteens: $viewModel.canteens,
                  selectedCanteen: $viewModel.selectedCanteen)
        }
        .edgesIgnoringSafeArea(.vertical)
        .navigationTitle("Map")
        .navigationBarHidden(true)
        .task {
            viewModel.fetchCanteens()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: MapViewModel())
    }
}
