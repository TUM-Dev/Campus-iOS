//
//  TUMSexyLink.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/24/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

@objc final class TUMSexyLink: NSManagedObject, Entity {
    
    enum CodingKeys: String, CodingKey {
        case link_description = "description"
        case moodle_id = "moodle_id"
        case target = "target"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let link_description = try container.decode(String.self, forKey: .link_description)
        let moodle_id = try container.decodeIfPresent(String.self, forKey: .moodle_id)
        let target = try container.decodeIfPresent(String.self, forKey: .target)
        
        self.init(entity: TUMSexyLink.entity(), insertInto: context)
        self.link_description = link_description
        self.moodle_id = moodle_id
        self.target = target
    }
}
