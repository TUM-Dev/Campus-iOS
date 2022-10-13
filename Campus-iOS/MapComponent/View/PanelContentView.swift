//
//  PanelContent.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 16.12.21.
//

import SwiftUI
import Alamofire

struct PanelContentView: View {
    @StateObject var vm: MapViewModel
    
    @State private var searchString = ""
    @State private var mealPlanViewModel: MealPlanViewModel?
    @State private var sortedGroups: [StudyRoomGroup] = []
    @State private var cafeteriasData = AppUsageData()
    @State private var studyRoomsData = AppUsageData()
    
    // TODO: For an unknown reason, .onDisappear on the PanelContentView is called when this view
    // shows for the first time. Setting this variable to true in .task and then checking it
    // in .onDisappear mitigates the issue.
    @State private var panelContentDidAppear = false
    
    @State var panelHeight: CGFloat = 0.0
    
    private let handleThickness = CGFloat(0)
    let dragAreaHeight = PanelHeight.top * 0.04
    
    var body: some View {
        ZStack {
            VStack {
                
                Spacer().frame(height: 10)
                
                RoundedRectangle(cornerRadius: CGFloat(5.0) / 2.0)
                    .frame(width: 40, height: CGFloat(5.0))
                    .foregroundColor(Color.primary.opacity(0.2))
                
                if vm.selectedCafeteria != nil {
                    CafeteriaView(vm: vm,
                                  selectedCanteen: $vm.selectedCafeteria,
                                  panelHeight: $panelHeight)
                    if let viewModel = mealPlanViewModel {
                        MealPlanView(viewModel: viewModel)
                    }
                    
                } else if vm.selectedStudyGroup != nil {
                    StudyRoomGroupView(
                        vm: vm,
                        selectedGroup: $vm.selectedStudyGroup,
                        rooms: vm.selectedStudyGroup?.getRooms(allRooms: vm.studyRoomsResponse.rooms ?? [StudyRoom]()) ?? [StudyRoom](),
                        panelHeight: $panelHeight
                    )
                } else {
                    HStack {
                        Spacer()
                        
                        Button (action: {
                            vm.zoomOnUser = true
                            if vm.panelPos == .top {
                                vm.panelPos = .middle
                            }
                        }) {
                            Image(systemName: "location")
                                .font(.title2)
                                .foregroundColor(Color(UIColor.tumBlue))
                        }
                        .simultaneousGesture(panelDragGesture)
                        
                        Spacer()
                        
                        PanelSearchBarView(vm: self.vm, searchString: $searchString)
                            .gesture(panelDragGesture)
                        
                        Spacer()
                        
                        HStack {
                            Picker("Places", selection: $vm.mode) {
                                ForEach(MapMode.allCases, id: \.self) {
                                    switch $0 {
                                    case .cafeterias:
                                        Image(systemName: "fork.knife")
                                    case .studyRooms:
                                        Image(systemName: "book.fill")
                                    }
                                }
                            }
                            .pickerStyle(.segmented)
                            .onAppear {
                                UISegmentedControl.appearance().backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
                                UISegmentedControl.appearance()
                                    .selectedSegmentTintColor = .tumBlue
                                UISegmentedControl.appearance()
                                    .setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                                UISegmentedControl.appearance()
                                    .setTitleTextAttributes([.foregroundColor: UIColor.useForStyle(dark: UIColor(red: 28/255, green: 171/255, blue: 246/255, alpha: 1), white: UIColor(red: 34/255, green: 126/255, blue: 177/255, alpha: 1))], for: .normal)
                            }
                            .gesture(panelDragGesture)
                        }
                        .frame(width: 100)
                        .onChange(of: vm.mode) { newMode in
                            if newMode == .cafeterias {
                                studyRoomsData.didExitView()
                                cafeteriasData.visitView(view: .cafeterias)
                            } else if newMode == .studyRooms {
                                cafeteriasData.didExitView()
                                studyRoomsData.visitView(view: .studyRooms)
                            }
                            vm.setAnnotations = true
                            for c in vm.cafeterias {
                                print(c.coordinate)
                            }
                        }
                
                        Spacer().frame(width: 0.25 * UIScreen.main.bounds.width/10, height: 50)
                    }
                    
                    Spacer()
                    
                    PanelContentListView(vm: self.vm, searchString: $searchString)
                        .task {
                            
                            panelContentDidAppear = true

                            if currentView() == .cafeterias {
                                cafeteriasData.visitView(view: .cafeterias)
                            } else if currentView() == .studyRooms {
                                studyRoomsData.visitView(view: .studyRooms)
                            }
                        }
                        .onDisappear {
                            
                            if !panelContentDidAppear { return }
                            
                            if currentView() == .cafeterias {
                                cafeteriasData.didExitView()
                            } else if currentView() == .studyRooms {
                                studyRoomsData.didExitView()
                            }
                        }
                }
            }
            .onChange(of: vm.selectedCafeteria) { optionalCafeteria in
                if let cafeteria = optionalCafeteria {
                    mealPlanViewModel = MealPlanViewModel(cafeteria: cafeteria)
                }
            }
            .task(id: vm.panelPos) {
                if panelHeight != vm.panelPos.rawValue {
                    withAnimation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0)) {
                        panelHeight = vm.panelPos.rawValue
                        print(panelHeight)
                    }
                }
            }
            
            VStack {
                Rectangle().foregroundColor(.clear)
                .contentShape(Rectangle())
                .cornerRadius(10, corners: [.topLeft, .topRight])
                .frame(height: dragAreaHeight, alignment: .top)
                .gesture(panelDragGesture)
                Spacer().frame(height: min(max((panelHeight) - dragAreaHeight, 0), PanelPos.top.rawValue))
            }
        }
    }
    
    private func currentView() -> CampusAppView {
        switch self.vm.mode {
        case MapMode.studyRooms: return .studyRooms
        case MapMode.cafeterias: return .cafeterias
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

struct PanelContentView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService(), mock: true)
        
        PanelContentView(vm: vm)
            .previewInterfaceOrientation(.portrait)
    }
}
