//
//  StudyRoomViewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 02.06.22.
//

import Foundation
import Alamofire

final class StudyRoomViewModel: ObservableObject {
    @Published var roomImageMapping = [RoomImageMapping]()
    @Published var room: StudyRoomCoreData
    
    private let endpoint: TUMCabeAPI
    private let sessionManager = Session.defaultSession
    
    init(studyRoom room: StudyRoomCoreData) {
        self.room = room
        self.endpoint = TUMCabeAPI.roomMaps(room: room.raum_nr_architekt ?? "")
        fetchImageMapping()
    }
    
    func fetchImageMapping() {
        sessionManager.request(endpoint).responseDecodable(of: [RoomImageMapping].self, decoder: JSONDecoder()) { [self] response in
            guard let mapping = response.value else {
                return
            }
            self.roomImageMapping = mapping
        }
    }
    
    func getImageURL(imageMappingId: Int) -> URL? {
        return TUMCabeAPI.mapImage(room: room.raum_nr_architekt ?? "", id: imageMappingId).urlRequest?.url
    }
}

final class FoundRoomViewModel: ObservableObject {
    @Published var roomImageMapping = [RoomImageMapping]()
    @Published var room: FoundRoom
    
    private let endpoint: TUMCabeAPI
    private let sessionManager = Session.defaultSession
    
    init(foundRoom room: FoundRoom) {
        self.room = room
        self.endpoint = TUMCabeAPI.roomMaps(room: room.id)
        fetchImageMapping()
    }
    
    func fetchImageMapping() {
        sessionManager.request(endpoint).responseDecodable(of: [RoomImageMapping].self, decoder: JSONDecoder()) { [self] response in
            guard let mapping = response.value else {
                return
            }
            self.roomImageMapping = mapping
        }
    }
    
    func getImageURL(imageMappingId: Int) -> URL? {
        return TUMCabeAPI.mapImage(room: room.id, id: imageMappingId).urlRequest?.url
    }
}
