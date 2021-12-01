//
//  TUMSexyLink.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/24/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

@objc final class TUMSexyLink: NSManagedObject, Identifiable, Entity {
    @NSManaged public var linkDescription: String?
    @NSManaged public var moodleID: String?
    @NSManaged public var target: String?
    
    enum CodingKeys: String, CodingKey {
        case linkDescription = "description"
        case moodleID = "moodle_id"
        case target = "target"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let linkDescription = try container.decode(String.self, forKey: .linkDescription)
        let moodleID = try container.decodeIfPresent(String.self, forKey: .moodleID)
        let target = try container.decodeIfPresent(String.self, forKey: .target)
        
        self.init(entity: TUMSexyLink.entity(), insertInto: context)
        self.linkDescription = linkDescription
        self.moodleID = moodleID
        self.target = target
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TUMSexyLink> {
        return NSFetchRequest<TUMSexyLink>(entityName: "TUMSexyLink")
    }
    
}
