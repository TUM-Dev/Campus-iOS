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
    
    private let handleThickness = CGFloat(0)
    
    var body: some View {
        VStack {
            
            Spacer().frame(height: 10)
            
            RoundedRectangle(cornerRadius: CGFloat(5.0) / 2.0)
                .frame(width: 40, height: CGFloat(5.0))
                .foregroundColor(Color.primary.opacity(0.2))
            
            if vm.selectedCafeteria != nil {
                CafeteriaView(selectedCanteen: $vm.selectedCafeteria)
                if let viewModel = mealPlanViewModel {
                    MealPlanView(viewModel: viewModel)
                }
                
            } else if vm.selectedStudyGroup != nil {
                StudyRoomGroupView(
                    selectedGroup: $vm.selectedStudyGroup,
                    rooms: vm.selectedStudyGroup?.getRooms(allRooms: vm.studyRoomsResponse.rooms ?? [StudyRoom]()) ?? [StudyRoom]()
                )
            }
            else {
                HStack {
                    Spacer()
                    
                    Button (action: {
                        vm.zoomOnUser = true
                        vm.panelPos = .middle
                    }) {
                        Image(systemName: "location")
                            .font(.title2)
                            .foregroundColor(Color(UIColor.tumBlue))
                    }
                    
                    Spacer()
                    
                    PanelSearchBarView(vm: self.vm, searchString: $searchString)
                    
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
                    }
                    .frame(width: 100)
                    .onChange(of: vm.mode) { newMode in
                        vm.setAnnotations = true
                    }
                    
                    //                    Menu(content: {
                    //                        Button(action: {
                    //                            self.mode = .cafeterias
                    //                            self.setAnnotations = true
                    //                        }, label: {
                    //                            Label("Cafeterias", systemImage: "fork.knife")
                    //                        })
                    //                        Button(action: {
                    //                            self.mode = .studyRooms
                    //                            self.setAnnotations = true
                    //                        }, label: {
                    //                            Label("Study Rooms", systemImage: "book.fill")
                    //                        })
                    //                    }) {
                    //                        if mode == .cafeterias {
                    //                            Image(systemName: "fork.knife")
                    //                        } else {
                    //                            Image(systemName: "book.fill")
                    //                        }
                    //                    }
                    
                    Spacer().frame(width: 0.25 * UIScreen.main.bounds.width/10, height: 50)
                }
                
                Spacer()
                
                PanelContentListView(vm: self.vm, searchString: $searchString)
            }
        }
        .onChange(of: vm.selectedCafeteria) { optionalCafeteria in
            if let cafeteria = optionalCafeteria {
                mealPlanViewModel = MealPlanViewModel(cafeteria: cafeteria)
            }
        }
    }
}

struct PanelContentView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService(), mock: true)
        
        PanelContentView(vm: vm)
            .previewInterfaceOrientation(.portrait)
    }
}
