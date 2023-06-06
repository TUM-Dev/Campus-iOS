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
    
    internal init(vm: AnnotatedMapViewModel, centerOfMap: CLLocationCoordinate2D, zoomLevel: Double) {
        self._vm = StateObject(wrappedValue: vm)
        self.region = MKCoordinateRegion(center: centerOfMap, span: MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel))
    }
    
    var body: some View {
        Label("View On Maps", systemImage: "map").titleStyle()
            .padding(.top, 20)
        
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: vm.locations) {item in
            MapAnnotation(coordinate: item.coordinate) {
                AnnotationView(location: item, vm: self.vm)
            }
        }
        .frame(width: Size.cardWidth, height: Size.cardWidth)
        .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
    }
}
