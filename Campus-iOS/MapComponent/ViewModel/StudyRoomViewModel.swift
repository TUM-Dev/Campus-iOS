//
//  StudyRoomVIewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 02.06.22.
//

import Foundation
import Alamofire

@MainActor
class StudyRoomViewModel: ObservableObject {
    @Published var state: APIState<[RoomImageMapping]> = .na
    @Published var hasError: Bool = false
    
    let service: StudyRoomsService = StudyRoomsService()
    
    func getRoomImageMapping(for room: StudyRoom, forcedRefresh: Bool = false) async {
        guard let raumNr = room.raum_nr_architekt else {
            return
        }
        
        if !forcedRefresh {
            self.state = .loading
        }
        self.hasError = false

        do {
            self.state = .success(
                data: try await service.fetchMap(room: raumNr, forcedRefresh: forcedRefresh)
            )
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
    
    func getImageURL(for room: StudyRoom, imageMappingId: Int) -> URL? {
        if let raumNr = room.raum_nr_architekt {
            return try? TUMCabeAPI.mapImage(room: raumNr, id: imageMappingId).asURLRequest().urlRequest?.url
        } else {
            return nil
        }
    }
}

//final class StudyRoomViewModel: ObservableObject {
//    @Published var roomImageMapping = [RoomImageMapping]()
//    @Published var room: StudyRoom
//
//    private let endpoint: TUMCabeAPI
//    private let sessionManager = Session.defaultSession
//
//    init(studyRoom room: StudyRoom) {
//        self.room = room
//        self.endpoint = TUMCabeAPI.roomMaps(room: String(room.raum_nr_architekt ?? ""))
//        fetchImageMapping()
//    }
//
//    func fetchImageMapping() {
//        sessionManager.request(endpoint).responseDecodable(of: [RoomImageMapping].self, decoder: JSONDecoder()) { [self] response in
//            guard let mapping = response.value else {
//                return
//            }
//            self.roomImageMapping = mapping
//        }
//    }
//
//    func getImageURL(imageMappingId: Int) -> URL? {
//        return TUMCabeAPI.mapImage(room: String(self.room.raum_nr_architekt ?? ""), id: imageMappingId).urlRequest?.url
//    }
//}
