//
//  CanteenView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 22.05.22.
//

import SwiftUI

struct CafeteriaView: View {
    @StateObject var vm: MapViewModel
    
    @Binding var selectedCanteen: Cafeteria?
    @State private var data = AppUsageData()
    
    @Binding var panelHeight: CGFloat
    let dragAreaHeight = PanelHeight.top * 0.04
    
    var body: some View {
        if let canteen = self.selectedCanteen {
            VStack {
                HStack{
                    VStack(alignment: .leading){
                        Text(canteen.name)
                            .bold()
                            .font(.title3)
                            .gesture(panelDragGesture)
                        Text(canteen.location.address)
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                            .gesture(panelDragGesture)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if vm.panelPos == .bottom {
                            vm.panelPos = .middle
                        }
                        selectedCanteen = nil
                    }, label: {
                        Text("Done")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.blue)
                            .padding(.all, 5)
                            .background(Color.clear)
                            .accessibility(label:Text("Close"))
                            .accessibility(hint:Text("Tap to close the screen"))
                            .accessibility(addTraits: .isButton)
                            .accessibility(removeTraits: .isImage)
                    })
                    .simultaneousGesture(panelDragGesture)
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        let latitude = canteen.location.latitude
                        let longitude = canteen.location.longitude
                        let url = URL(string: "maps://?saddr=&daddr=\(latitude),\(longitude)")
                        
                        if UIApplication.shared.canOpenURL(url!) {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        }
                    }, label: {
                        Text("Show Directions \(Image(systemName: "arrow.right.circle"))")
                            .foregroundColor(.blue)
                            .font(.footnote)
                    })
                    .simultaneousGesture(panelDragGesture)
                }
            }
            .padding(.all, 10)
            .task {
                data.visitView(view: .cafeteria)
            }
            .onDisappear {
                data.didExitView()
            }
            .contentShape(Rectangle())
            .gesture(panelDragGesture)
        }
    }
    
    var panelDragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                guard !vm.lockPanel else { return }
                panelHeight = panelHeight - value.translation.height
            }
            .onEnded { _ in
                withAnimation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0)) {
                    snapPanel(from: panelHeight)
                }
            }
    }
    
    func snapPanel(from height: CGFloat) {
        let snapHeights = [PanelPos.top, PanelPos.middle, PanelPos.bottom]
        
        vm.panelPos = closestMatch(values: snapHeights, inputValue: height)
        panelHeight = vm.panelPos.rawValue
    }
    
    func closestMatch(values: [PanelPos], inputValue: CGFloat) -> PanelPos {
        return (values.reduce(values[0]) { abs($0.rawValue-inputValue) < abs($1.rawValue-inputValue) ? $0 : $1 })
    }
}

struct CanteenView_Previews: PreviewProvider {
    @State static var ph: CGFloat = 0.0
    static var vm = MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService(), mock: true)
    
    static var previews: some View {
        CafeteriaView(vm: vm, selectedCanteen: .constant(nil), panelHeight: $ph)
            .previewInterfaceOrientation(.portrait)
    }
}
