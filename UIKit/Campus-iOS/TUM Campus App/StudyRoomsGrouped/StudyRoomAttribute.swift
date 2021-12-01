//
//  StudyRoomAttributes.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/26/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

@objc final class StudyRoomAttribute: NSManagedObject, Identifiable, Entity {
    @NSManaged public var detail: String?
    @NSManaged public var name: String?
    @NSManaged public var studyRoom: StudyRoom?

    enum CodingKeys: String, CodingKey {
        case detail
        case name
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let detail = try container.decode(String.self, forKey: .detail)
        let name = try container.decode(String.self, forKey: .name)
        
        self.init(entity: StudyRoomAttribute.entity(), insertInto: context)
        self.detail = detail
        self.name = name
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudyRoomAttribute> {
        return NSFetchRequest<StudyRoomAttribute>(entityName: "StudyRoomAttribute")
    }
    
}
