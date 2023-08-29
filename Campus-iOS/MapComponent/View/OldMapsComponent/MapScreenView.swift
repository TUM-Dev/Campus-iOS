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
    
    var panelHeight: CGFloat = 0.0 // Start position of panel is defined in `MapViewModel` with the `panelPos` porperty.
    
    init(vm: MapViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    
    var body: some View {
        // -> Here check the status of the fetched cafeterias
        ZStack {
            MapContentView(vm: self.vm)
            VStack{
                Spacer()
                ZStack {
                    VStack {
                        PanelContentView(vm: self.vm, panelHeight: panelHeight)
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(10, corners: [.topRight, .topLeft])
                            .shadow(radius: 10)
                            .frame(height: panelHeight, alignment: .bottom)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .ignoresSafeArea(.keyboard)
        .navigationTitle("Map")
        .navigationBarHidden(true)
    }
}

struct MapScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            MapScreenView(vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService(), mock: true))
        }
        
    }
}
