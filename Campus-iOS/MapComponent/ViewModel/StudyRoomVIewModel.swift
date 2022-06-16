//
//  StudyRoomVIewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 02.06.22.
//

import Foundation
import Alamofire

final class StudyRoomViewModel: ObservableObject {
    @Published var roomImageMapping = [RoomImageMapping]()
    @Published var room: StudyRoom
    
    private let endpoint: TUMCabeAPI
    private let sessionManager = Session.defaultSession
    
    init(studyRoom room: StudyRoom) {
        self.room = room
        self.endpoint = TUMCabeAPI.roomMaps(room: String(room.raum_nr_architekt ?? ""))
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
        return TUMCabeAPI.mapImage(room: String(self.room.raum_nr_architekt ?? ""), id: imageMappingId).urlRequest?.url
    }
}
