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
    @Binding var canteens: [Cafeteria]
    @State var d = testData
    
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
                        self.zoomOnUser = true
                    }) {
                        Image(systemName: "location")
                            .font(.title2)
                    }
                    Spacer().frame(width: 8.75 * UIScreen.main.bounds.width/10,
                                   height: 1.25 * UIScreen.main.bounds.width/10)
                }
                List {
                    ForEach(canteens, id: \.self) { item in
                        VStack {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Spacer().frame(height: 5)
                                    Text(item.name)
                                        .bold()
                                        .font(.title2)
                                    Spacer().frame(height: 0)
                                    HStack {
                                        Text(item.location.address)
                                            .font(.subheadline)
                                            .foregroundColor(Color.gray)
                                        Spacer().frame(width: 20)
                                    }
                                    Spacer().frame(height: 0)
                                }
                                Spacer()
                                Button (action: {
                                }) {
                                    Image(systemName: "doc.plaintext")
                                        .font(.title)
                                }
                            }
                        }
                    }
                }.listStyle(PlainListStyle())
            }
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
}

struct ListData: Identifiable,Hashable {
    var id = UUID()
    var canteen_id: String
    var name: String
    var adress: String
    var latitude: Double
    var longitude: Double
}

var testData = [
    ListData(canteen_id:  "mensa-arcisstr", name: "Mensa Arcisstraße", adress:  "Arcisstraße 17, München", latitude: 48.147420, longitude: 11.567220),
    ListData(canteen_id:  "mensa-arcisstr", name: "Mensa Arcisstraße", adress:  "Arcisstraße 17, München", latitude: 48.147420, longitude: 11.567220),
    ListData(canteen_id:  "mensa-arcisstr", name: "Mensa Arcisstraße", adress:  "Arcisstraße 17, München", latitude: 48.147420, longitude: 11.567220),
    ListData(canteen_id:  "mensa-arcisstr", name: "Mensa Arcisstraße", adress:  "Arcisstraße 17, München", latitude: 48.147420, longitude: 11.567220),
    ListData(canteen_id:  "mensa-arcisstr", name: "Mensa Arcisstraße", adress:  "Arcisstraße 17, München", latitude: 48.147420, longitude: 11.567220),
    ListData(canteen_id:  "mensa-arcisstr", name: "Mensa Arcisstraße", adress:  "Arcisstraße 17, München", latitude: 48.147420, longitude: 11.567220),
    ListData(canteen_id:  "mensa-arcisstr", name: "Mensa Arcisstraße", adress:  "Arcisstraße 17, München", latitude: 48.147420, longitude: 11.567220),
    ListData(canteen_id:  "mensa-arcisstr", name: "Mensa Arcisstraße", adress:  "Arcisstraße 17, München", latitude: 48.147420, longitude: 11.567220)
]

struct PanelContent_Previews: PreviewProvider {
    static var previews: some View {
        PanelContent(zoomOnUser: .constant(true), canteens: .constant([]))
            .previewInterfaceOrientation(.landscapeRight)
    }
}
