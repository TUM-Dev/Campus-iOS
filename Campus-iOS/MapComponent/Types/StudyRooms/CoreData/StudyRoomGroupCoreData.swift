//
//  StudyRoomGroupCoreData.swift
//  Campus-iOS
//
//  Created by David Lin on 21.11.22.
//

import Foundation
import CoreData
import MapKit

class StudyRoomGroupCoreData: NSManagedObject, Decodable {
    
    static var all: NSFetchRequest<StudyRoomGroupCoreData> {
        let request = StudyRoomGroupCoreData.fetchRequest()
        request.sortDescriptors = []
        return request
    }
    
    enum CodingKeys: String, CodingKey {
        case detail = "detail"
        case name = "name"
        case id = "nr"
        case sorting = "sortierung"
        case rooms = "raeume"
    }
    
    enum DecoderConfigurationError: Error {
      case missingManagedObjectContext
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let managedObjectContext = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext,
                let entity = NSEntityDescription.entity(forEntityName: "StudyRoomGroupCoreData", in: managedObjectContext) else {
              throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(entity: entity, insertInto: managedObjectContext)

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
    
    func getRooms(allRooms rooms: [StudyRoomCoreData]) -> [StudyRoomCoreData] {
        rooms.filter({ self.rooms?.contains($0.id) ?? false })
    }
}
