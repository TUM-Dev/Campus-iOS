//
//  AnnotatedMapView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 06.06.23.
//

import SwiftUI
import MapKit

struct AnnotatedMapView: View {
    
    @StateObject var vm: AnnotatedMapViewModel
    @State private var region: MKCoordinateRegion
    
    internal init(vm: AnnotatedMapViewModel, centerOfMap: CLLocationCoordinate2D) {
        self._vm = StateObject(wrappedValue: vm)
        self.region = MKCoordinateRegion(center: centerOfMap, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
    
    var body: some View {
        Label("View On Maps", systemImage: "map").titleStyle()
            .padding(.top, 20)
        
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: vm.locations) {item in
            MapAnnotation(coordinate: item.coordinate) {
                AnnotationView(item: item)
            }
        }
        .frame(width: Size.cardWidth, height: Size.cardWidth)
        .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
    }
}
