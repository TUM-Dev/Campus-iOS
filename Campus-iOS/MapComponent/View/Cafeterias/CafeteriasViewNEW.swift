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
                ForEach (self.sortedCafeterias.indices, id: \.self) { id in
                    CafeteriaViewNEW(cafeteria: self.sortedCafeterias[id])
                }
            }
        }
    }
}
