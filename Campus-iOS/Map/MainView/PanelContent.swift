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
    @Binding var zoomOnUser: Bool
    @Binding var panelPosition: String
    @Binding var canteens: [Cafeteria]
    @Binding var selectedCanteenName: String
    @Binding var selectedAnnotationIndex: Int
    @Binding var selectedCanteen: Cafeteria
    
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
                .frame(width: .infinity, height: handleThickness)
                .foregroundColor(Color.secondary)
                .padding(5)
            VStack {
                HStack {
                    Button (action: {
                        zoomOnUser = true
                        selectedAnnotationIndex = 0
                        if panelPosition == "up" {
                            panelPosition = "pushMid"
                        }
                    }) {
                        Image(systemName: "location")
                            .font(.title2)
                    }
                    .padding(.horizontal, 10)
                    
                    SearchBar(panelPosition: $panelPosition,
                              searchString: $searchString,
                              selectedCanteenName: $selectedCanteenName,
                              selectedAnnotationIndex: $selectedAnnotationIndex)
                    
                    Spacer().frame(width: 0.25 * UIScreen.main.bounds.width/10,
                                   height: 1.5 * UIScreen.main.bounds.width/10)
                }
                ZStack {
                    ProgressView()
                    ScrollViewReader { proxy in
                        List {
                            ForEach (canteens.indices.filter({ searchString.isEmpty ? true : canteens[$0].name.localizedCaseInsensitiveContains(searchString) }), id: \.self) { id in
                                PanelRow(cafeteria: self.$canteens[id])
                                .onTapGesture {
                                    withAnimation {
                                        selectedCanteenName = canteens[id].name
                                        selectedAnnotationIndex = canteens.firstIndex(of: canteens[id])!
                                        proxy.scrollTo(canteens[id], anchor: .top)
                                        
                                        selectedCanteen = canteens[id]
                                    }
                                }
                                .task(id: selectedAnnotationIndex) {
                                    withAnimation(Animation.linear(duration: 0.0001)) {
                                        if 0...canteens.count ~= selectedAnnotationIndex {
                                            proxy.scrollTo(canteens[selectedAnnotationIndex], anchor: .top)
                                            selectedAnnotationIndex = -1
                                        }
                                    }
                                }
                            }

                        }
                    }
                    .searchable(text: $searchString, prompt: "Look for something")
                    .listStyle(PlainListStyle())
                }
                .onChange(of: selectedCanteenName) { newValue in
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

struct PanelContent_Previews: PreviewProvider {
    static var previews: some View {
        PanelContent(zoomOnUser: .constant(true),
                     panelPosition: .constant(""),
                     canteens: .constant([testCafeteria]),
                     selectedCanteenName: .constant(""),
                     selectedAnnotationIndex: .constant(0), selectedCanteen: .constant(testCafeteria))
            .previewInterfaceOrientation(.portrait)
    }
}
