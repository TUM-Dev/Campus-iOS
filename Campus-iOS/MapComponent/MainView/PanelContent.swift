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
    @State private var canteenForMealPlan: Cafeteria?
    @State private var goToMealPlan = false
        
    let endpoint = EatAPI.canteens
    let sessionManager = Session.defaultSession
    var locationManager = CLLocationManager()
    
    private let handleThickness = CGFloat(0)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: handleThickness / 2.0)
                .frame(height: handleThickness)
                .foregroundColor(Color.secondary)
                .padding(5)
            VStack {
                HStack {
                    Button (action: {
                        vm.zoomOnUser = true
                        vm.selectedAnnotationIndex = 0
                        if vm.panelPosition == "up" {
                            vm.panelPosition = "pushMid"
                        }
                    }) {
                        Image(systemName: "location")
                            .font(.title2)
                    }
                    .padding(.horizontal, 10)
                    
                    SearchBar(panelPosition: $vm.panelPosition,
                              searchString: $searchString,
                              selectedCanteenName: $vm.selectedCafeteriaName,
                              selectedAnnotationIndex: $vm.selectedAnnotationIndex)
                    
                    Spacer().frame(width: 0.25 * UIScreen.main.bounds.width/10,
                                   height: 1.5 * UIScreen.main.bounds.width/10)
                }
                ZStack {
                    ProgressView()
                    ScrollViewReader { proxy in
                        List {
                            ForEach (vm.cafeterias.indices.filter({ searchString.isEmpty ? true : vm.cafeterias[$0].name.localizedCaseInsensitiveContains(searchString) }), id: \.self) { id in
                                PanelRow(cafeteria: self.vm.cafeterias[id])
                                .onTapGesture {
                                    print("TAPPED")
                                    withAnimation {
                                        vm.selectedCafeteriaName = vm.cafeterias[id].name
                                        vm.selectedAnnotationIndex = vm.cafeterias.firstIndex(of: vm.cafeterias[id])!
                                        proxy.scrollTo(vm.cafeterias[id], anchor: .top)
                                        
                                        vm.selectedCafeteria = vm.cafeterias[id]
                                    }
                                    print(vm.selectedCafeteria)
                                }
                                .task(id: vm.selectedAnnotationIndex) {
                                    withAnimation(Animation.linear(duration: 0.0001)) {
                                        if 0...vm.cafeterias.count ~= vm.selectedAnnotationIndex {
                                            proxy.scrollTo(vm.cafeterias[vm.selectedAnnotationIndex], anchor: .top)
                                            vm.selectedAnnotationIndex = -1
                                        }
                                    }
                                }
                            }

                        }
                    }
                    .searchable(text: $searchString, prompt: "Look for something")
                    .listStyle(PlainListStyle())
                }
                .onChange(of: vm.selectedCafeteriaName) { newValue in
                    print("SELECTED CANTEEN (Panelcontent): ", newValue)
                }
            }
        }
    }
}

struct SearchBar: View {
    @Binding var panelPosition: String
    @Binding var searchString: String
    @Binding var selectedCanteenName: String
    @Binding var selectedAnnotationIndex: Int
    
    @State private var isEditing = false
    
    var body: some View {
        ZStack {
            TextField("Search ...", text: $searchString)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onTapGesture {
                    isEditing = true
                    panelPosition = "pushMid"
                }
            HStack {
                Spacer()
                if self.searchString != "" {
                    Button(action: {
                        self.searchString = ""
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
                searchString = ""
                
                selectedCanteenName = ""
                selectedAnnotationIndex = -1
                panelPosition = "pushDown"
                
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }) {
                Text("Cancel")
            }
            .padding(.trailing, 10)
            .transition(.move(edge: .trailing))
        }
    }
}

/*struct PanelContent_Previews: PreviewProvider {
    static var previews: some View {
        PanelContent(zoomOnUser: .constant(true),
                     panelPosition: .constant(""),
                     canteens: .constant([]),
                     selectedCanteenName: .constant(""),
                     selectedAnnotationIndex: .constant(0),
                     canteenForMealPlan: <#Cafeteria#>)
            .previewInterfaceOrientation(.portrait)
    }
}*/
