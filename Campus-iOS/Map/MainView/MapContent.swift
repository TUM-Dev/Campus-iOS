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
    @ObservedObject var vm: MapViewModel
    
    let endpoint = EatAPI.canteens
    let sessionManager = Session.defaultSession
    var locationManager = CLLocationManager()
    public let mapView = MKMapView()
    
    let screenHeight = UIScreen.main.bounds.height
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        handleCafeterias()
        
        
        mapView.showsUserLocation = true
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        focusOnUser(mapView: view)
        focusOnCanteen(mapView: view)
        
        let newCenter = screenHeight/3
        
        if vm.panelPosition == "mid" || vm.panelPosition == "pushMid"{
            view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: newCenter, right: 0)
        } else if vm.panelPosition == "down" || vm.panelPosition == "pushDown"{
            view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func focusOnUser(mapView: MKMapView) {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
            
            if let location = self.locationManager.location {
                if vm.zoomOnUser {
                    DispatchQueue.main.async {
                        for i in mapView.selectedAnnotations {
                            mapView.deselectAnnotation(i, animated: true)
                        }
                        
                        vm.selectedCanteenName = ""
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
        if vm.selectedCanteenName != "" {
            for i in mapView.annotations {
                if i.title == vm.selectedCanteenName {
                    let locValue: CLLocationCoordinate2D = i.coordinate
                    
                    let coordinate = CLLocationCoordinate2D(
                        latitude: locValue.latitude, longitude: locValue.longitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    let region = MKCoordinateRegion(center: coordinate, span: span)
                    
                    
                    mapView.setRegion(region, animated: true)
                    mapView.selectAnnotation(i, animated: true)
                    
                }
            }
        }
    }
    
    func makeCoordinator() -> MapContentCoordinator {
        MapContentCoordinator(self)
    }
    
    func handleCafeterias() {
        let annotations = vm.cafeterias.map { Annotation(title: $0.name, coordinate: $0.coordinate) }
        
        mapView.addAnnotations(annotations)
    }
    
}

class MapContentCoordinator: NSObject, MKMapViewDelegate {
    var control: MapContent
    
    init(_ control: MapContent) {
        self.control = control
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        DispatchQueue.main.async { [self] in
            control.vm.zoomOnUser = false
            control.vm.selectedCanteenName = ""
            control.vm.selectedAnnotationIndex = -1
        }
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
            DispatchQueue.main.async { [self] in
                
                if !control.vm.cafeterias.isEmpty {
                    for i in 0...(control.vm.cafeterias.count - 1) {
                        if title! == control.vm.cafeterias[i].title {
                            control.vm.selectedAnnotationIndex = i
                            control.vm.panelPosition = "pushMid"
                        }
                    }
                }
            }
        }
    }
}
