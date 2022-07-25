//
//  Panel.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 16.12.21.
//

import SwiftUI
import MapKit

struct PanelView: View {
    @GestureState private var dragState = DragState.inactive
    @State var position = PanelPosition.bottom
    @StateObject var vm: MapViewModel
                                   
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                if vm.lockPanel == false {
                    state = .dragging(translation: drag.translation)
                }
            }
            .onEnded(onDragEnded)
        
        return Group {
            VStack{
                PanelContentView(vm: self.vm)
                //Spacer().frame(width: screenWidth, height: screenHeight)
            }
        }
        .frame(height: screenHeight)
        .background()
        .cornerRadius(10.0)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.2), radius: 10.0)
        .offset(y: self.position.rawValue + self.dragState.translation.height)
        .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0), value: self.dragState.isDragging)
        .gesture(drag)
        .task(id: vm.panelPosition) {
            print("PANEL POS: \(vm.panelPosition)")
            withAnimation {
                if vm.panelPosition == "pushKBTop" {
                    self.position = .kbtop
                } else if vm.panelPosition == "pushMid" {
                    self.position = .middle
                } else if vm.panelPosition == "pushDown" {
                    self.position = .bottom
                } else if vm.panelPosition == "pushTop" {
                    self.position = .top
                }
            }
        }
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        if vm.lockPanel == false {
            let verticalDirection = drag.predictedEndLocation.y - drag.location.y
            let cardTopEdgeLocation = self.position.rawValue + drag.translation.height
            let positionAbove: PanelPosition
            let positionBelow: PanelPosition
            let closestPosition: PanelPosition
            
            if cardTopEdgeLocation <= PanelPosition.top.rawValue {
                positionAbove = .top
                positionBelow = .top
                
                closestPosition = positionAbove
                
            } else if cardTopEdgeLocation <= PanelPosition.middle.rawValue && cardTopEdgeLocation >= PanelPosition.top.rawValue {
                positionAbove = .top
                positionBelow = .middle
                
                if cardTopEdgeLocation < (positionBelow.rawValue - positionAbove.rawValue) {
                    closestPosition = positionAbove
                } else {
                    closestPosition = positionBelow
                }
            } else {
                positionAbove = .middle
                positionBelow = .bottom
                
                if (cardTopEdgeLocation - positionAbove.rawValue)/4 < (positionBelow.rawValue - cardTopEdgeLocation) {
                    closestPosition = positionAbove
                } else {
                    closestPosition = positionBelow
                }
            }
            
            if verticalDirection > 100 {
                self.position = positionBelow
            } else if verticalDirection < -100 {
                self.position = positionAbove
            } else {
                self.position = closestPosition
            }
            
            if self.position.rawValue == PanelPosition.bottom.rawValue {
                vm.panelPosition = "down"
            } else if self.position.rawValue == PanelPosition.middle.rawValue {
                vm.panelPosition = "mid"
            } else if self.position.rawValue == PanelPosition.top.rawValue {
                vm.panelPosition = "up"
            }
        }
    }
}

let screenHeight = UIScreen.main.bounds.height

enum PanelPosition: CGFloat {
    case top, kbtop, middle, bottom
    var rawValue: CGFloat {
        switch self {
        case .top: return (1.2/10) * screenHeight
        case .kbtop: return (2.5/10) * screenHeight
        case .middle: return (5/10) * screenHeight
        case .bottom: return (8.3/10) * screenHeight
        }
    }
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}

struct PanelView_Previews: PreviewProvider {
    @Binding var selectedCanteen: Cafeteria?

    static var previews: some View {
        PanelView(vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()))
    }
}