//
//  CafeteriaViewNEW.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 25.04.23.
//

import SwiftUI
import MapKit

struct CafeteriasView: View {
    @StateObject var vm: MapViewModel
    @State var sortedCafeterias: [Cafeteria]
    var vmAnno = AnnotatedMapViewModel()
    var locationManager = CLLocationManager()
    
    init(vm: MapViewModel) {
        self._vm = StateObject(wrappedValue: vm)
        //sorts cafeterias based on distance from user
        if let location = self.locationManager.location {
            self.sortedCafeterias = vm.cafeterias.sorted {
                $0.coordinate.location.distance(from: location) < $1.coordinate.location.distance(from: location)
            }
        } else {
            self.sortedCafeterias = vm.cafeterias
        }
        vmAnno.addCafeterias(cafeterias: self.sortedCafeterias)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                AnnotatedMapView(vm: vmAnno, centerOfMap: CLLocationCoordinate2D(latitude: 48.1372, longitude: 11.5755), zoomLevel: 0.3)
                
                CafeteriasListView(vm: self.vmAnno)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.primaryBackground)
    }
}
