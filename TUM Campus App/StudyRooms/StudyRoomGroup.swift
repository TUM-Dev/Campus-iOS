//
//  StudyRoomGroup.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/24/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

@objc final class StudyRoomGroup: NSManagedObject, Entity {
    
    enum CodingKeys: String, CodingKey {
        case detail
        case name
        case nr
        case sortierung
        case raeume
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let detail = try container.decode(String.self, forKey: .detail)
        let name = try container.decode(String.self, forKey: .name)
        let nr = try container.decode(Int64.self, forKey: .nr)
        let sortierung = try container.decode(Int64.self, forKey: .sortierung)
        let room_nrs = try container.decode([Int64].self, forKey: .raeume)
        
        let roomFetchRequest: NSFetchRequest<StudyRoom> = StudyRoom.fetchRequest()
        roomFetchRequest.predicate = NSPredicate(format: "\(StudyRoom.CodingKeys.raum_nr.rawValue) IN %@", room_nrs)
        let rooms = try context.fetch(roomFetchRequest)

        self.init(entity: StudyRoomGroup.entity(), insertInto: context)
        self.detail = detail
        self.name = name
        self.nr = nr
        self.sortierung = sortierung
        self.raeume = NSSet(array: rooms)
    }
}

