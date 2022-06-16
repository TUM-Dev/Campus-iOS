//
//  StudyRoomApiResponse.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.05.22.
//

import Foundation

struct StudyRoomApiRespose: Entity, Equatable {
    static func == (lhs: StudyRoomApiRespose, rhs: StudyRoomApiRespose) -> Bool {
        lhs.groups?.map({$0.id}) == rhs.groups?.map({$0.id}) &&
        lhs.rooms?.map({$0.id}) == rhs.rooms?.map({$0.id})
    }
    
    var rooms: [StudyRoom]?
    var groups: [StudyRoomGroup]?
    
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

        let rooms = try container.decode([StudyRoom].self, forKey: .rooms)
        let groups = try container.decode([StudyRoomGroup].self, forKey: .groups)
        
        self.rooms = rooms
        self.groups = groups
    }
}
