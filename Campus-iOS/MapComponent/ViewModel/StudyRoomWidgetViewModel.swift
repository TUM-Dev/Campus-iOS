//
//  StudyRoomWidgetViewModel.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 25.06.22.
//

import Foundation
import MapKit
import Alamofire
import CoreData

@MainActor
class StudyRoomWidgetViewModel: ObservableObject {
    
    @Published var studyGroup: StudyRoomGroupCoreData?
    @Published var rooms: [StudyRoomCoreData]?
    @Published var status: StudyRoomWidgetStatus
    
    private let studyRoomService: StudyRoomsServiceProtocol
    private let sessionManager = Session.defaultSession
    
    private let locationManager = CLLocationManager()
    
    let vm: MapViewModel
    
    init(context: NSManagedObjectContext, studyRoomService: StudyRoomsServiceProtocol) {
        self.status = .loading
        self.studyRoomService = studyRoomService
        
        let authorization = locationManager.authorizationStatus
        if authorization != .authorizedWhenInUse || authorization != .authorizedAlways {
            locationManager.requestWhenInUseAuthorization()
        }
        
        self.vm = MapViewModel(context: context, cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService())
    }
    
    func fetch() async {
        do {
            try await vm.getRoomsAndGroups()
            
            // Get the closest study group.
            
            guard let location = CLLocationManager().location else {
                self.status = .error
                return
            }
            
            guard let group = vm.studyRoomGroups.min(
                by: { ($0.coordinate?.location.distance(from: location)) ?? 0.0 < $1.coordinate?.location.distance(from: location) ?? 0.0}
            ) else {
                self.status = .error
                return
            }
            
            self.studyGroup = group
            self.rooms = studyGroup?.getRooms(allRooms: vm.studyRooms)
            
            self.status = .success
        } catch {
            print(error)
            self.status = .error
        }
    }
}


enum StudyRoomWidgetStatus {
    case success, error, loading
}
