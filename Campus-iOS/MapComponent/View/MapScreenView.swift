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
    @State var panelHeight = UIScreen.main.bounds.height * 0.8
    
    init(vm: MapViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    
    var body: some View {
        // -> Here check the status of the fetched cafeterias
        ZStack {
            MapContentView(vm: self.vm)
            VStack{
                Spacer()
                VStack {
                    PanelContentView(vm: self.vm)
                        .background(Color.white)
                        .cornerRadius(10, corners: [.topRight, .topLeft])
                        .shadow(radius: 10)
                        .frame(height: panelHeight, alignment: .bottomTrailing)
                        .gesture(
                            DragGesture(minimumDistance: 15)
                                .onChanged { value in
                                    //if !vm.lockPanel {
//                                        DispatchQueue.main.async {
//                                            vm.panelHeight = vm.panelHeight - value.translation.height
//                                        }
                                        panelHeight = panelHeight - value.translation.height
                                        print("Change \(panelHeight)")
//                                    }
//
                                }
//                                .onEnded { value in
//                                    vm.panelHeight = panelHeight
//                                }
                        )
                }
            }
        }.edgesIgnoringSafeArea(.top)
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
