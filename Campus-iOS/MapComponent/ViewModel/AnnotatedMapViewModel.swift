//
//  AnnotatedMapViewModel.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 05.06.23.
//

import Foundation

@MainActor
class AnnotatedMapViewModel: ObservableObject {
    
    @Published var locations = [TUMLocation]()
    @Published var cafeterias = [Cafeteria]()
    @Published var studyRoomGroups = [StudyRoomGroup]()
    @Published var rooms = [NavigaTumNavigationEntity]()
    @Published var annotationCloser = false //remove
    @Published var openAnnotation: UUID?
    
    func addCafeterias(cafeterias: [Cafeteria]) {
        locations.append(contentsOf: cafeterias.map {TUMLocation(cafeteria: $0)})
        self.cafeterias.append(contentsOf: cafeterias)
    }
    
    func addStudyRoomGroups(studyRoomGroups: [StudyRoomGroup]) {
        locations.append(contentsOf: studyRoomGroups.map {TUMLocation(studyRoomGroup: $0)})
        self.studyRoomGroups.append(contentsOf: studyRoomGroups)
    }
    
    func addRooms(rooms: [NavigaTumNavigationEntity]) async {
        for room in rooms {
            let tempVM = NavigaTumDetailsViewModel(id: room.id)
            await tempVM.fetchDetails()
            if let details = tempVM.details {
                locations.append(TUMLocation(room: room, details: tempVM.details!))
            }
        }
        self.rooms.append(contentsOf: rooms)
    }
}
