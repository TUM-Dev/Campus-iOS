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
    @State var canteens: [Cafeteria]
    @State var selectedCanteenName: String
    @State var selectedAnnotationIndex: Int
    
    var body: some View {
        ZStack {
            MapContent(
                zoomOnUser: $zoomOnUser,
                panelPosition: $panelPosition,
                canteens: $canteens,
                selectedCanteenName: $selectedCanteenName,
                selectedAnnotationIndex: $selectedAnnotationIndex)
            Panel(zoomOnUser: $zoomOnUser,
                  panelPosition: $panelPosition,
                  canteens: $canteens,
                  selectedCanteenName: $selectedCanteenName,
                  selectedAnnotationIndex: $selectedAnnotationIndex)
            Toolbar(zoomOnUser: $zoomOnUser, selectedCanteenName: $selectedCanteenName)
        }
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("Map")
        .navigationBarHidden(true)
    }
}

/*struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(zoomOnUser: true,
                panelPosition: "down",
                canteens: [],
                selectedCanteenName: "",
                selectedAnnotationIndex: 0)
    }
}*/
