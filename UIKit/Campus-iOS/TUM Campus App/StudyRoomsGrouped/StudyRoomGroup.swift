//
//  StudyRoomGroup.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/24/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

@objc final class StudyRoomGroup: NSManagedObject, Identifiable, Entity {
    @NSManaged public var detail: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var sorting: Int64
    @NSManaged public var rooms: NSSet?

    @objc(addRoomsObject:)
    @NSManaged public func addToRooms(_ value: StudyRoom)

    @objc(removeRoomsObject:)
    @NSManaged public func removeFromRooms(_ value: StudyRoom)

    @objc(addRooms:)
    @NSManaged public func addToRooms(_ values: NSSet)

    @objc(removeRooms:)
    @NSManaged public func removeFromRooms(_ values: NSSet)
    
    enum CodingKeys: String, CodingKey {
        case detail = "detail"
        case name = "name"
        case id = "nr"
        case sorting = "sortierung"
        case rooms = "raeume"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let detail = try container.decode(String.self, forKey: .detail)
        let name = try container.decode(String.self, forKey: .name)
        let id = try container.decode(Int64.self, forKey: .id)
        let sorting = try container.decode(Int64.self, forKey: .sorting)
        let room_nrs = try container.decode([Int64].self, forKey: .rooms)
        
        let roomFetchRequest: NSFetchRequest<StudyRoom> = StudyRoom.fetchRequest()
        roomFetchRequest.predicate = NSPredicate(format: "%K IN %@", #keyPath(StudyRoom.id), room_nrs)
        let rooms = try context.fetch(roomFetchRequest)

        self.init(entity: StudyRoomGroup.entity(), insertInto: context)
        self.detail = detail
        self.name = name
        self.id = id
        self.sorting = sorting
        self.rooms = NSSet(array: rooms)
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudyRoomGroup> {
        return NSFetchRequest<StudyRoomGroup>(entityName: "StudyRoomGroup")
    }

}

