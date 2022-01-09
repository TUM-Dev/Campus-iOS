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
    
    @State private var searchString = ""
        
    let endpoint = EatAPI.canteens
    let sessionManager = Session.defaultSession
    var locationManager = CLLocationManager()
    
    private static let distanceFormatter: MKDistanceFormatter = {
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .abbreviated
        return formatter
    }()
    
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
                            ForEach (canteens.filter({ searchString.isEmpty ? true : $0.name.contains(searchString) }), id: \.self) { item in
                                VStack {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Spacer().frame(height: 5)
                                            HStack {
                                                Text(item.name)
                                                    .bold()
                                                    .font(.title3)
                                                Spacer()
                                                Button (action: {
                                                }) {
                                                    Image(systemName: "doc.plaintext")
                                                        .font(.title3)
                                                }
                                            }
                                            Spacer().frame(height: 0)
                                            HStack {
                                                Text(item.location.address)
                                                    .font(.subheadline)
                                                    .foregroundColor(Color.gray)
                                                Spacer()
                                                Text(distance(cafeteria: item))
                                                    .font(.subheadline)
                                                    .foregroundColor(Color.gray)
                                            }
                                            Spacer().frame(height: 0)
                                        }
                                    }
                                }
                                .onTapGesture {
                                    withAnimation {
                                        selectedCanteenName = item.name
                                        selectedAnnotationIndex = canteens.index(of: item)!
                                        proxy.scrollTo(item, anchor: .top)
                                    }
                                }
                                .task(id: selectedAnnotationIndex) {
                                    print(selectedAnnotationIndex)
                                    withAnimation(Animation.linear(duration: 0.0001)) {
                                        if 0...canteens.count ~= selectedAnnotationIndex {
                                            proxy.scrollTo(canteens[selectedAnnotationIndex], anchor: .top)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    ._scrollable()
                    .searchable(text: $searchString, prompt: "Look for something")
                    .listStyle(PlainListStyle())
                }
            }
        }
        .onAppear {
            fetch()
        }
    }
    
    func fetch() {
        sessionManager.request(endpoint).responseDecodable(of: [Cafeteria].self, decoder: JSONDecoder()) { [self] response in
            var cafeterias: [Cafeteria] = response.value ?? []
            if let currentLocation = self.locationManager.location {
                cafeterias.sortByDistance(to: currentLocation)
            }
            
            self.canteens = cafeterias
            
            /*var snapshot = NSDiffableDataSourceSnapshot<Section, Cafeteria>()
            snapshot.appendSections([.main])
            snapshot.appendItems(cafeterias, toSection: .main)
            self?.dataSource?.apply(snapshot, animatingDifferences: true)*/
        }
    }
    
    func distance(cafeteria: Cafeteria) -> String {
        if let currentLocation = self.locationManager.location {
            let distance = cafeteria.coordinate.location.distance(from: currentLocation)
            return PanelContent.distanceFormatter.string(fromDistance: distance)
        }
        return ""
    }
}

struct SearchBar: View {
    @Binding var panelPosition: String
    @Binding var searchString: String
    @Binding var selectedCanteenName: String
    @Binding var selectedAnnotationIndex: Int
    
    @State private var isEditing = false
    
    var body: some View {
        TextField("Search ...", text: $searchString)
            .padding(7)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .onTapGesture {
                isEditing = true
                panelPosition = "pushMid"
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
                     canteens: .constant([]),
                     selectedCanteenName: .constant(""),
                     selectedAnnotationIndex: .constant(0))
            .previewInterfaceOrientation(.portrait)
    }
}
