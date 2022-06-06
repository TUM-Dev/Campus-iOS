//
//  PanelContent.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 16.12.21.
//

import SwiftUI
import MapKit
import CoreLocation
import Alamofire

struct PanelContent: View {
    @StateObject var vm: MapViewModel
    
    @State private var searchString = ""
    @State private var mealPlanViewModel: MealPlanViewModel?
    @State var sortedCafeterias: [Cafeteria] = mockCafeterias
        
    let endpoint = EatAPI.canteens
    let sessionManager = Session.defaultSession
    var locationManager = CLLocationManager()
    
    private let handleThickness = CGFloat(0)
    
    var body: some View {
        VStack{
            Spacer().frame(height: 10)
            
            RoundedRectangle(cornerRadius: CGFloat(5.0) / 2.0)
                        .frame(width: 40, height: CGFloat(5.0))
                        .foregroundColor(Color.black.opacity(0.2))
            
            if let cafeteria = vm.selectedCafeteria {
                HStack{
                    VStack(alignment: .leading){
                        Text(cafeteria.name)
                            .bold()
                            .font(.title3)
                        Text(cafeteria.location.address)
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                    }
                    
                    Spacer()

                    Button(action: {
                        vm.selectedCafeteria = nil
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
                }
                .padding(.all, 10)
                
                if let viewModel = mealPlanViewModel {
                    MealPlanView(viewModel: viewModel)
                }
                
                Spacer()
            }
            else {
                HStack {
                    Spacer()
                    
                    Button (action: {
                        vm.zoomOnUser = true
                        if vm.panelPosition == "up" {
                            vm.panelPosition = "pushMid"
                        }
                    }) {
                        Image(systemName: "location")
                            .font(.title2)
                    }
                    
                    Spacer()
                    
                    SearchBar(panelPosition: $vm.panelPosition,
                              lockPanel: $vm.lockPanel,
                              searchString: $searchString)
                    
                    Spacer().frame(width: 0.25 * UIScreen.main.bounds.width/10,
                                   height: 1.5 * UIScreen.main.bounds.width/10)
                }
                
                List {
                    ForEach (sortedCafeterias.indices.filter({ searchString.isEmpty ? true : sortedCafeterias[$0].name.localizedCaseInsensitiveContains(searchString) }), id: \.self) { id in
                        Button(action: {
                            vm.selectedCafeteria = sortedCafeterias[id]
                            vm.panelPosition = "pushMid"
                            vm.lockPanel = false
                        }, label: {
                            PanelRow(cafeteria: self.$sortedCafeterias[id])
                        })
                    }
                }
                .searchable(text: $searchString, prompt: "Look for something")
                .listStyle(PlainListStyle())
            }
        }
        .onAppear(perform: {
            if vm.self is MockMapViewModel {
                self.sortedCafeterias = mockCafeterias
            } else {
                self.sortedCafeterias = vm.cafeterias
            }
            
        })
        .onChange(of: vm.selectedCafeteria) { optionalCafeteria in
            if let cafeteria = optionalCafeteria {
                mealPlanViewModel = MealPlanViewModel(cafeteria: cafeteria)
            }
        }
        .onChange(of: vm.cafeterias) { unsortedCafeterias in
            if let location = self.locationManager.location {
                sortedCafeterias = unsortedCafeterias.sorted {
                    $0.coordinate.location.distance(from: location) < $1.coordinate.location.distance(from: location)
                }
            }
            else {
                sortedCafeterias = unsortedCafeterias
            }
        }
    }
}

struct SearchBar: View {
    @Binding var panelPosition: String
    @Binding var lockPanel: Bool
    @Binding var searchString: String
    
    @State var isEditing = false
    
    var body: some View {
        TextField("Search ...", text: $searchString, onEditingChanged: { (editingChanged) in
            if editingChanged {
                isEditing = true
                lockPanel = true
                panelPosition = "pushKBTop"
            } else {
                isEditing = false
                lockPanel = false
            }
        })
            .padding(7)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay {
                HStack {
                    Spacer()
                    if !self.searchString.isEmpty {
                        Button(action: {
                            self.searchString = ""
                            lockPanel = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color(UIColor.opaqueSeparator))
                        }
                        .padding(.trailing, 8)
                    }
                }
            }

        if isEditing {
            Button(action: {
                isEditing = false
                lockPanel = false
                searchString = ""
                                
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }) {
                Text("Cancel")
            }
            .padding(.trailing, 10)
            .transition(.move(edge: .trailing))
        }
    }
}

struct PanelContent_Previews: PreviewProvider {
    static var previews: some View {
        let vm = MockMapViewModel(service: MockCafeteriasService())
        
        PanelContent(vm: vm)
            .previewInterfaceOrientation(.portrait)
    }
}
