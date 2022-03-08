//
//  PanelContent.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 16.12.21.
//

import SwiftUI
import CoreLocation

struct PanelContent: View {
    @Binding var zoomOnUser: Bool
    @Binding var panelPosition: String
    @Binding var canteens: [Cafeteria]
    @Binding var selectedCanteen: Cafeteria?
    
    @State private var searchString = ""
        
    var locationManager = CLLocationManager()
    
    private let handleThickness = CGFloat(0)
    
    var body: some View {
        VStack {
            HStack {
                Button (action: {
                    zoomOnUser = true
                    if panelPosition == "up" {
                        panelPosition = "pushMid"
                    }
                }) {
                    Image(systemName: "location")
                        .font(.title2)
                }
                .padding(.horizontal, 10)
                
                SearchBar(panelPosition: $panelPosition,
                          searchString: $searchString)
                
                Spacer().frame(width: 0.25 * UIScreen.main.bounds.width/10,
                               height: 1.5 * UIScreen.main.bounds.width/10)
            }
            
            List {
                ForEach (canteens.indices.filter({ searchString.isEmpty ? true : canteens[$0].name.localizedCaseInsensitiveContains(searchString) }), id: \.self) { id in
                    PanelRow(cafeteria: self.$canteens[id])
                    .onTapGesture {
                        selectedCanteen = canteens[id]
                    }
                }
                
                //TODO: check for better way, to make last items in list available
                Spacer().frame(width: UIScreen.main.bounds.width,
                               height: 0.25 * UIScreen.main.bounds.height)
            }
            .searchable(text: $searchString, prompt: "Look for something")
            .listStyle(PlainListStyle())
        }
    }
}

struct SearchBar: View {
    @Binding var panelPosition: String
    @Binding var searchString: String
    
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
                     canteenForMealPlan: <#Cafeteria#>)
            .previewInterfaceOrientation(.portrait)
    }
}*/
