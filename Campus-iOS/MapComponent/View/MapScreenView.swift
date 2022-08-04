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
    
    @State var panelHeight: CGFloat = 0.0 // Start position of panel is defined in `MapViewModel` with the `panelPos` porperty.
    
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
                        PanelContentView(vm: self.vm)
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(10, corners: [.topRight, .topLeft])
                            .shadow(radius: 10)
                            .frame(height: panelHeight, alignment: .bottomTrailing)
                            .task(id: vm.panelPos) {
                                if panelHeight != vm.panelPos.rawValue {
                                    withAnimation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0)) {
                                        panelHeight = vm.panelPos.rawValue
                                        print(panelHeight)
                                    }
                                }
                            }
                    }
                    
                    VStack {
//                        Spacer()
                        let dragAreaHeight = PanelHeight.top*0.04
                        
                        Rectangle().foregroundColor(.clear)
                        .contentShape(Rectangle())
                        .cornerRadius(10, corners: [.topLeft, .topRight])
                        .frame(height: dragAreaHeight, alignment: .top)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    guard !vm.lockPanel else { return }
                                    if let newPanelHeight = check(panelHeight - value.translation.height) {
                                        panelHeight = newPanelHeight
                                    }
                                }
                                .onEnded { _ in
                                    withAnimation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0)) {
                                        snapPanel(from: panelHeight)
                                    }
                                }
                        )
                        Spacer().frame(height: min(max(panelHeight-dragAreaHeight,0), PanelPos.top.rawValue))
                    }
                }
            }
        }.edgesIgnoringSafeArea(.top)
            .navigationTitle("Map")
            .navigationBarHidden(true)
    }
    
    func check(_ height: CGFloat) -> CGFloat? {
        return height <= PanelHeight.top && height >= PanelHeight.bottom ? height : nil
    }
    
    func snapPanel(from height: CGFloat) {
        print(height)
        let snapHeights = [PanelPos.top, PanelPos.middle, PanelPos.bottom]
        
        vm.panelPos = closestMatch(values: snapHeights, inputValue: height)
        panelHeight = vm.panelPos.rawValue
    }
    
    func closestMatch(values: [PanelPos], inputValue: CGFloat) -> PanelPos {
        return (values.reduce(values[0]) { abs($0.rawValue-inputValue) < abs($1.rawValue-inputValue) ? $0 : $1 })
    }
}

struct MapScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            MapScreenView(vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService(), mock: true))
        }
        
    }
}
