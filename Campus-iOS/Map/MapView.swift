//
//  MapView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 16.12.21.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State var zoomOnUser: Bool
    @State var panelPosition: String
    
    var body: some View {
        ZStack {
            MapContent(zoomOnUser: $zoomOnUser, panelPosition: $panelPosition)
            Panel(zoomOnUser: $zoomOnUser, panelPosition: $panelPosition)
        }
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("")
        .navigationBarHidden(true)
        .onAppear {
            UITabBar.appearance().isOpaque = true
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(zoomOnUser: true, panelPosition: "down")
    }
}
