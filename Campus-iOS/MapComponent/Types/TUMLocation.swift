//
//  TUMLocation.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 05.06.23.
//

import Foundation
import MapKit
import SwiftUI

struct TUMLocation: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
    var symbol: Image
    var annotationController = false
    
    var studyRoomGroup: StudyRoomGroup?
    var cafeteria: Cafeteria?
    
    var room: NavigaTumNavigationEntity?
    var roomDetails: NavigaTumNavigationDetails?

    init(name: String, coordinate: CLLocationCoordinate2D, symbol: Image) {
        self.name = name
        self.coordinate = coordinate
        self.symbol = symbol
    }
    
    init(cafeteria: Cafeteria) {
        self.name = cafeteria.name
        self.coordinate = cafeteria.coordinate
        self.symbol = Image(systemName: "fork.knife.circle.fill")
        self.cafeteria = cafeteria
    }
    
    init(studyRoomGroup: StudyRoomGroup) {
        self.name = studyRoomGroup.name ?? ""
        self.coordinate = studyRoomGroup.coordinate ?? CLLocationCoordinate2D()
        self.symbol = Image(systemName: "pencil.circle.fill")
        self.studyRoomGroup = studyRoomGroup
    }
    
    init(room: NavigaTumNavigationEntity, details: NavigaTumNavigationDetails) {
        self.name = room.name
        self.coordinate = CLLocationCoordinate2D(latitude: details.coordinates.latitude, longitude: details.coordinates.longitude)
        self.symbol = Image(systemName: "graduationcap.circle.fill")
        self.room = room
        self.roomDetails = details
    }
    
    init(campus: Campus) {
        self.name = campus.rawValue
        self.coordinate = campus.location.coordinate
        self.symbol = Image(systemName: "building.2.crop.circle.fill")
    }
}
