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

struct MapContent: UIViewRepresentable {
    @Binding var zoomOnUser: Bool
    @Binding var panelPosition: String
    @Binding var canteens: [Cafeteria]
    
    let endpoint = EatAPI.canteens
    let sessionManager = Session.defaultSession
    var locationManager = CLLocationManager()
    public let mapView = MKMapView()
    
    let screenHeight = UIScreen.main.bounds.height
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        DispatchQueue.main.async {
            fetchCanteens()
        }
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.showsUserLocation = true

        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        focusOnUser()
        
        let newCenter = screenHeight/3
        
        if panelPosition == "up" {
            view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: newCenter, right: 0)
        } else if panelPosition == "down" {
            view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        func focusOnUser() {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()

                if zoomOnUser {
                    DispatchQueue.main.async {
                        if let location = self.locationManager.location {
                            let locValue: CLLocationCoordinate2D = location.coordinate
                            
                            let coordinate = CLLocationCoordinate2D(
                                latitude: locValue.latitude, longitude: locValue.longitude)
                            let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                            let region = MKCoordinateRegion(center: coordinate, span: span)
                            
                            view.setRegion(region, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> MapContentCoordinator {
        MapContentCoordinator(self)
    }
    
    var allCafs: [Cafeteria] = []
    
    func fetchCanteens() {
            sessionManager.request(endpoint).responseDecodable(of: [Cafeteria].self, decoder: JSONDecoder()) { [self] response in
                var cafeterias: [Cafeteria] = response.value ?? []
                if let currentLocation = self.locationManager.location {
                    cafeterias.sortByDistance(to: currentLocation)
                }
                
                mapView.addAnnotations(response.value ?? [])
                
                canteens = cafeterias

                /*var snapshot = NSDiffableDataSourceSnapshot<Section, Cafeteria>()
                snapshot.appendSections([.main])
                snapshot.appendItems(cafeterias, toSection: .main)
                self?.dataSource?.apply(snapshot, animatingDifferences: true)*/
            }
        }
    
    class MapContentCoordinator: NSObject, MKMapViewDelegate {
        var control: MapContent
            
        init(_ control: MapContent) {
            self.control = control
        }
        
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            control.zoomOnUser = false
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            print(view.annotation?.title)
            //selectedCanteen = view.annotation?.title
        }
    }
}
