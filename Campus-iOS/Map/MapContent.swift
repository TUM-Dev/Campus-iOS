//
//  MapContent.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 16.12.21.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapContent: UIViewRepresentable {
    @Binding var zoomOnUser: Bool
    
    var locationManager = CLLocationManager()
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.showsUserLocation = true

        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
            if zoomOnUser {
                print("THIS SHIT SHOULD ZOOM ON THE USER")
                DispatchQueue.main.async {
                    if let location = self.locationManager.location{
                        let locValue: CLLocationCoordinate2D = location.coordinate
                        
                        let coordinate = CLLocationCoordinate2D(
                            latitude: locValue.latitude, longitude: locValue.longitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                        let region = MKCoordinateRegion(center: coordinate, span: span)
                        
                        view.setRegion(region, animated: true)
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> MapContentCoordinator {
        MapContentCoordinator(self)
    }
    
    class MapContentCoordinator: NSObject, MKMapViewDelegate {
        var control: MapContent
            
        init(_ control: MapContent) {
            self.control = control
        }
        
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            control.zoomOnUser = false
        }
    }
}
