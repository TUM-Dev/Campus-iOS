//
//  MapContent.swift
//  Campus-iOS
//
//  Created by ghjtd hbmu on 16.12.21.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapContent: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
           MKMapView(frame: .zero)
       }
       
   func updateUIView(_ view: MKMapView, context: Context) {
       let coordinate = CLLocationCoordinate2D(
           latitude: -33.523065, longitude: 151.394551)
       let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
       let region = MKCoordinateRegion(center: coordinate, span: span)
       view.setRegion(region, animated: true)
   }
}

struct MapContent_Previews: PreviewProvider {
    static var previews: some View {
        MapContent()
    }
}
