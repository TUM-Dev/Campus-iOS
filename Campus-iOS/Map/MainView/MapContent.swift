//
//  MapContent.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 16.12.21.
//

import SwiftUI
import MapKit
import CoreLocation
import Alamofire

final class Annotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    
    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        super.init()
    }
}

struct MapContent: UIViewRepresentable {
    @Binding var zoomOnUser: Bool
    @Binding var panelPosition: String
    @Binding var canteens: [Cafeteria]
    @Binding var selectedCanteen: Cafeteria?
    
    @State private var focusedCanteen: Cafeteria?
        
    let endpoint = EatAPI.canteens
    let sessionManager = Session.defaultSession
    var locationManager = CLLocationManager()
    public let mapView = MKMapView()
    
    let screenHeight = UIScreen.main.bounds.height
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        
        mapView.showsUserLocation = true

        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        focusOnUser(mapView: view)
        focusOnCanteen(mapView: view)
        
        if view.annotations.count == 0 && canteens.count > 0 {
            let annotations = canteens.map { Annotation(title: $0.name, coordinate: $0.coordinate) }
            view.addAnnotations(annotations)
        }
        
        let newCenter = screenHeight/3
        
        if panelPosition == "mid" || panelPosition == "pushMid"{
            view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: newCenter, right: 0)
        } else if panelPosition == "down" || panelPosition == "pushDown"{
            view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func focusOnUser(mapView: MKMapView) {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()

            if let location = self.locationManager.location {
                if zoomOnUser {
                    for i in mapView.selectedAnnotations {
                        mapView.deselectAnnotation(i, animated: true)
                    }
                    
                    DispatchQueue.main.async {
                        let locValue: CLLocationCoordinate2D = location.coordinate
                        
                        let coordinate = CLLocationCoordinate2D(
                            latitude: locValue.latitude, longitude: locValue.longitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                        let region = MKCoordinateRegion(center: coordinate, span: span)
                        
                        withAnimation {
                            mapView.setRegion(region, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func focusOnCanteen(mapView: MKMapView) {        
        if selectedCanteen != nil && selectedCanteen != focusedCanteen, let canteen = selectedCanteen {
            for i in mapView.annotations {
                if i.title == canteen.title {
                    let locValue: CLLocationCoordinate2D = i.coordinate
                    
                    let coordinate = CLLocationCoordinate2D(
                        latitude: locValue.latitude, longitude: locValue.longitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    let region = MKCoordinateRegion(center: coordinate, span: span)
                    
                    DispatchQueue.main.async {
                        mapView.setRegion(region, animated: true)
                        mapView.selectAnnotation(i, animated: true)
                        focusedCanteen = selectedCanteen // only focus once, when newly selected
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
                
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let coordinate = view.annotation?.coordinate {
                let locValue: CLLocationCoordinate2D = coordinate
                
                let coordinate = CLLocationCoordinate2D(
                    latitude: locValue.latitude, longitude: locValue.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                
                mapView.setRegion(region, animated: true)
            }
            
            if let title = view.annotation?.title {
                for canteen in control.canteens{
                    if title! == canteen.title {
                        control.selectedCanteen = canteen
                        control.panelPosition = "pushMid"
                    }
                }
            }
        }
    }
}
