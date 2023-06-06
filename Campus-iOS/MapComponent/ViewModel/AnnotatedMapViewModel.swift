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
            await locations.append(TUMLocation(room: room))
        }
        self.rooms.append(contentsOf: rooms)
    }
}
