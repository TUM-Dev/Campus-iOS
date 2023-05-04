//
//  CafeteriaViewNEW.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 25.04.23.
//

import SwiftUI
import MapKit

struct CafeteriasViewNEW: View {
    @StateObject var vm: MapViewModel
    @State var sortedCafeterias: [Cafeteria]
    @State private var pointsOfInterest = [AnnotatedItem]()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.1372, longitude: 11.5755), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
    
    var locationManager = CLLocationManager()
    
    init(vm: MapViewModel) {
        self._vm = StateObject(wrappedValue: vm)
        if let location = self.locationManager.location {
            self.sortedCafeterias = vm.cafeterias.sorted {
                $0.coordinate.location.distance(from: location) < $1.coordinate.location.distance(from: location)
            }
        } else {
            self.sortedCafeterias = vm.cafeterias
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Label("View On Maps", systemImage: "map").titleStyle()
                    .padding(.top, 20)
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: pointsOfInterest) {item in
                    MapAnnotation(coordinate: item.coordinate) {
                        PlaceAnnotationView(symbol: item.symbol)
                    }
                }
                .frame(width: Size.cardWidth, height: Size.cardWidth)
                .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
                Label("Cafeterias", systemImage: "fork.knife").titleStyle()
                    .padding(.top, 20)
                ForEach (self.sortedCafeterias.indices, id: \.self) { id in
                    CafeteriaViewNEW(cafeteria: self.sortedCafeterias[id])
                        .task {
                            self.pointsOfInterest.append(AnnotatedItem(name: self.sortedCafeterias[id].name, coordinate: self.sortedCafeterias[id].coordinate, symbol: Image(systemName: "fork.knife.circle.fill")))
                        }
                    Divider().padding(.horizontal)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.primaryBackground)
    }
    
    struct AnnotatedItem: Identifiable {
        let id = UUID()
        var name: String
        var coordinate: CLLocationCoordinate2D
        var symbol: Image
    }
    
    struct PlaceAnnotationView: View {
        var symbol: Image
        var body: some View {
            VStack(spacing: 0) {
                symbol
                    .resizable()
                    .foregroundColor(Color.highlightText)
                    .frame(width: 20, height: 20)
                    .background(.white)
                    .clipShape(Circle())
                
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.caption)
                    .foregroundColor(Color.highlightText)
                    .offset(x: 0, y: -5)
            }
        }
    }
}
