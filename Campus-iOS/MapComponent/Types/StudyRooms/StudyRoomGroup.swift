//
//  StudyRoomGroup.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.05.22.
//

import Foundation
import MapKit

struct StudyRoomGroup: Entity, Equatable {
    var detail: String?
    var id: Int64
    var name: String?
    var sorting: Int64
    var rooms: [Int64]?
    
    enum CodingKeys: String, CodingKey {
        case detail = "detail"
        case name = "name"
        case id = "nr"
        case sorting = "sortierung"
        case rooms = "raeume"
    }
    
    var coordinate: CLLocationCoordinate2D? {
        switch(self.id) {
        case 44:
            return CLLocationCoordinate2D(latitude: 48.24926355557732, longitude: 11.633834370828435)
        case 46:
            return CLLocationCoordinate2D(latitude: 48.2629811953867, longitude: 11.6668123)
        case 47:
            return CLLocationCoordinate2D(latitude: 48.26250533403169, longitude: 11.668024666454896)
        case 60:
            return CLLocationCoordinate2D(latitude: 48.14778663798231, longitude: 11.56695764027295)
        case 97:
            return CLLocationCoordinate2D(latitude: 48.26696368721545, longitude: 11.670222023419445)
        case 130:
            return CLLocationCoordinate2D(latitude: 48.39535098293569, longitude: 11.724272313959853)
        default:
            return nil;
        }
    }
    
    init() {
        self.id = 0
        self.sorting = 0
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let detail = try container.decode(String.self, forKey: .detail)
        let name = try container.decode(String.self, forKey: .name)
        let id = try container.decode(Int64.self, forKey: .id)
        let sorting = try container.decode(Int64.self, forKey: .sorting)
        let room_nrs = try container.decode([Int64].self, forKey: .rooms)
        
        self.detail = detail
        self.name = name
        self.id = id
        self.sorting = sorting
        self.rooms = room_nrs
    }
    
    func getRooms(allRooms rooms: [StudyRoom]) -> [StudyRoom]? {
        rooms.filter({ self.rooms?.contains($0.id) ?? false })
    }
}
