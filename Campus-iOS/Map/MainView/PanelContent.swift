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
    @State private var mealPlanViewModel: MealPlanViewModel?
    @State private var sortedCanteens: [Cafeteria] = []
        
    var locationManager = CLLocationManager()
    
    private let handleThickness = CGFloat(0)
    
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: CGFloat(5.0) / 2.0)
                        .frame(width: 40, height: CGFloat(5.0))
                        .foregroundColor(Color.secondary)
                        .padding(5)
            
            if let canteen = selectedCanteen {
                HStack{
                    VStack(alignment: .leading){
                        Text(canteen.name)
                            .bold()
                            .font(.title3)
                        Text(canteen.location.address)
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                            .onTapGesture{
                                let latitude = canteen.location.latitude
                                let longitude = canteen.location.longitude
                                let url = URL(string: "maps://?saddr=&daddr=\(latitude),\(longitude)")
                                
                                if UIApplication.shared.canOpenURL(url!) {
                                      UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                }
                            }
                    }
                    
                    Spacer()

                    Button(action: {
                        selectedCanteen = nil
                    }, label: {
                        Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.all, 5)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                                .accessibility(label:Text("Close"))
                                .accessibility(hint:Text("Tap to close the screen"))
                                .accessibility(addTraits: .isButton)
                                .accessibility(removeTraits: .isImage)
                        })
                }
                .padding(.all, 10)
                
                if let viewModel = mealPlanViewModel{
                    MealPlanView(viewModel: viewModel)
                }
                
                Spacer()
            }
            else {
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
                    ForEach (sortedCanteens.indices.filter({ searchString.isEmpty ? true : sortedCanteens[$0].name.localizedCaseInsensitiveContains(searchString) }), id: \.self) { id in
                        Button(action: {
                            selectedCanteen = sortedCanteens[id]
                        }, label: {
                            PanelRow(cafeteria: self.$sortedCanteens[id])
                        })
                    }
                }
                .searchable(text: $searchString, prompt: "Look for something")
                .listStyle(PlainListStyle())
            }
        }
        .onChange(of: selectedCanteen) { optionalCafeteria in
            if let cafeteria = optionalCafeteria {
                mealPlanViewModel = MealPlanViewModel(cafeteria: cafeteria)
            }
        }
        .onChange(of: canteens) { unsortedCanteens in
            if let location = self.locationManager.location {
                sortedCanteens = unsortedCanteens.sorted {
                    $0.coordinate.location.distance(from: location) < $1.coordinate.location.distance(from: location)
                }
            }
            else {
                sortedCanteens = unsortedCanteens
            }
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
