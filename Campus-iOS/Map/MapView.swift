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
    
    var body: some View {
        ZStack {
            MapContent(zoomOnUser: $zoomOnUser)
            Panel(zoomOnUser: $zoomOnUser)
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
        MapView(zoomOnUser: true)
    }
}
