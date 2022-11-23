//
//  StudyRoomApiResponseCoreData.swift
//  Campus-iOS
//
//  Created by David Lin on 23.11.22.
//

import Foundation

struct StudyRoomApiResponseCoreData: Entity, Equatable {
    static func == (lhs: StudyRoomApiResponseCoreData, rhs: StudyRoomApiResponseCoreData) -> Bool {
        lhs.groups?.map({$0.id}) == rhs.groups?.map({$0.id}) &&
        lhs.rooms?.map({$0.id}) == rhs.rooms?.map({$0.id})
    }
    
    var rooms: [StudyRoomCoreData]?
    var groups: [StudyRoomGroupCoreData]?
    
    enum CodingKeys: String, CodingKey {
        case rooms = "raeume"
        case groups = "gruppen"
    }
    
    init() {
        self.rooms = nil
        self.groups = nil
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let rooms = try container.decode([StudyRoomCoreData].self, forKey: .rooms)
        let groups = try container.decode([StudyRoomGroupCoreData].self, forKey: .groups)
        
        self.rooms = rooms
        self.groups = groups
    }
}

