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

struct MapContentView: UIViewRepresentable {
  
    @ObservedObject var vm: MapViewModel
  
    @State private var focusedCanteen: Cafeteria?
    @State private var focusedGroup: StudyRoomGroup?

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
    
    func removeAnnotationsButUser(_ view: MKMapView) {
        let userLocation = view.userLocation
        view.removeAnnotations(view.annotations)
        view.addAnnotation(userLocation)
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        focusOnUser(mapView: view)
        switch vm.mode {
        case .cafeterias:
            focusOnCanteen(mapView: view)
            if vm.cafeterias.count > 0 && vm.setAnnotations {
                DispatchQueue.main.async {
                    let annotations = vm.cafeterias.map { Annotation(title: $0.name, coordinate: $0.coordinate) }
                    removeAnnotationsButUser(view)
                    view.addAnnotations(annotations)
                    vm.setAnnotations = false // only add canteen annotations once
                }
            }
        case .studyRooms:
            focusOnStudyGroup(mapView: view)
            if let groups = vm.studyRoomsResponse.groups, groups.count > 0, vm.setAnnotations {
                DispatchQueue.main.async {
                    let annotations = groups.map {
                        Annotation(title: $0.name, coordinate: $0.coordinate ?? CLLocationCoordinate2D(latitude: 48.149691364160894, longitude: 11.567925766109836))
                    }
                    removeAnnotationsButUser(view)
                    view.addAnnotations(annotations)
                    vm.setAnnotations = false // only add study room annotations once
                }
            }
        }
        
        let newCenter = screenHeight/3
        
        if vm.panelPos == .middle {
            view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: newCenter, right: 0)
        } else if vm.panelPos == .bottom {
            view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func focusOnUser(mapView: MKMapView) {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
            
            if let location = self.locationManager.location {
                if vm.zoomOnUser {
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
        if let cafeteria = vm.selectedCafeteria, cafeteria != focusedCanteen {
            for i in mapView.annotations {
                if i.title == cafeteria.title {
                    let locValue: CLLocationCoordinate2D = i.coordinate
                    
                    let coordinate = CLLocationCoordinate2D(
                        latitude: locValue.latitude, longitude: locValue.longitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    let region = MKCoordinateRegion(center: coordinate, span: span)
                    
                    DispatchQueue.main.async {
                        mapView.setRegion(region, animated: true)
                        mapView.selectAnnotation(i, animated: true)
                        focusedCanteen = vm.selectedCafeteria // only focus once, when newly selected
                    }
                }
            }
        }
    }
    
    func focusOnStudyGroup(mapView: MKMapView) {
        if let selectedGroup = vm.selectedStudyGroup, selectedGroup != focusedGroup {
            for i in mapView.annotations {
                if i.title == selectedGroup.name {
                    let locValue: CLLocationCoordinate2D = i.coordinate
                    
                    let coordinate = CLLocationCoordinate2D(
                        latitude: locValue.latitude, longitude: locValue.longitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    let region = MKCoordinateRegion(center: coordinate, span: span)
                    
                    DispatchQueue.main.async {
                        mapView.setRegion(region, animated: true)
                        mapView.selectAnnotation(i, animated: true)
                        focusedGroup = vm.selectedStudyGroup // only focus once, when newly selected
                    }
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
    var control: MapContentView
    
    init(_ control: MapContentView) {
        self.control = control
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        DispatchQueue.main.async { [self] in
            control.vm.zoomOnUser = false
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
                        if title == control.vm.cafeterias[i].title {
                            control.vm.selectedAnnotationIndex = i
                            // Making the selected annotation (i.e. cafeteria) the selected cafeteria -> shows the MealPlanView inside the PanelContentView like tapping on a cafeteria in the PanelContentCafeteriasListView
                            control.vm.selectedCafeteria = control.vm.cafeterias[i]
                            //control.vm.panelPosition = "pushMid"
                            control.vm.panelPos = .middle
                        }
                    }
                }
                if let groups = control.vm.studyRoomsResponse.groups, groups.count > 0 {
                    for i in 0...(groups.count - 1) {
                        if title == groups[i].name {
                            control.vm.selectedAnnotationIndex = i
                            // Making the selected annotation (i.e. study group) the selected study group -> shows the StudyRoomGroupView with inside the PanelContentView like tapping on a study group in the PanelContentStudyRoomGroupsListView
                            control.vm.selectedStudyGroup = groups[i]
                            control.vm.panelPos = .middle
                        }
                    }
                }
            }
        }
    }
}
