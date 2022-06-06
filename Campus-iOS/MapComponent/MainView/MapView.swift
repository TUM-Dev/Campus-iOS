//
//  MapView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 16.12.21.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var vm: MapViewModel
    
    var body: some View {
        ZStack {
            MapContent(
                vm: self.vm)
            Panel(vm: self.vm)
        }
        .edgesIgnoringSafeArea(.vertical)
        .navigationTitle("Map")
        .navigationBarHidden(true)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(vm: MapViewModel(service: CafeteriasService()))
    }
}
