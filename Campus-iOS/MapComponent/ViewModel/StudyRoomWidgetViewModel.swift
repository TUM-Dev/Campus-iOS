//
//  StudyRoomWidgetViewModel.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 25.06.22.
//

import Foundation
import MapKit
import Alamofire

@MainActor
class StudyRoomWidgetViewModel: ObservableObject {
    
    @Published var studyGroup: StudyRoomGroup?
    @Published var rooms: [StudyRoom]?
    @Published var status: StudyRoomWidgetStatus
    
    private let studyRoomService: StudyRoomsServiceProtocol
    private let sessionManager = Session.defaultSession
    
    init(studyRoomService: StudyRoomsServiceProtocol) {
        self.status = .loading
        self.studyRoomService = studyRoomService
    }
    
    func fetch() async {
        do {
            let response = try await studyRoomService.fetch(forcedRefresh: false)
            
            // Get the closest study group.
            
            guard let location = CLLocationManager().location else {
                self.status = .error
                return
            }
            
            guard let group = response.groups?.min(
                by: { ($0.coordinate?.location.distance(from: location)) ?? 0.0 < $1.coordinate?.location.distance(from: location) ?? 0.0}
            ), let rooms = response.rooms else {
                self.status = .error
                return
            }
            
            self.studyGroup = group
            self.rooms = studyGroup?.getRooms(allRooms: rooms)
            
            self.status = .success
        } catch {
            self.status = .error
        }
    }
}


enum StudyRoomWidgetStatus {
    case success, error, loading
}
