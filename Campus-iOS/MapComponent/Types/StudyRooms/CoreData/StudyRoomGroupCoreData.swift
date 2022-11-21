//
//  StudyRoomGroupCoreData.swift
//  Campus-iOS
//
//  Created by David Lin on 21.11.22.
//

import Foundation
import CoreData

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
                let entity = NSEntityDescription.entity(forEntityName: "StudyRoomCoreData", in: managedObjectContext) else {
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
        self.rooms = room_nrs as NSObject
    }
    
}
