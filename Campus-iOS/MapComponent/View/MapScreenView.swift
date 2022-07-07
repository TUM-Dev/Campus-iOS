//
//  MapScreen.swift
//  Campus-iOS
//
//  Created by David Lin on 05.06.22.
//

import SwiftUI

@MainActor
struct MapScreenView: View {
    @StateObject var vm: MapViewModel
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.width
    
    @State var position = PanelPosition.bottom
    
    init(vm: MapViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    
    var body: some View {
        // -> Here check the status of the fetched cafeterias
        ZStack {
            MapContentView(vm: self.vm)
            PanelView(vm: self.vm)
        }.edgesIgnoringSafeArea(.vertical)
            .navigationTitle("Map")
            .navigationBarHidden(true)
    }
}

struct MapScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MapScreenView(vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService(), mock: true))
    }
}
