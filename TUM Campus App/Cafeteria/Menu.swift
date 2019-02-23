//
//  Menu.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/23/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

@objc class Menu: NSManagedObject, Entity {
    
    /*
     {
        "id": "697159",
        "mensa_id": "422",
        "date": "2019-03-01",
        "type_short": "tg",
        "type_long": "Tagesgericht 1",
        "type_nr": "1",
        "name": "Spanischer Gemüseeintopf"
     },
 */
    
    /*
     @NSManaged public var date: Date?
     @NSManaged public var id: Int64
     @NSManaged public var mensa_id: Int64
     @NSManaged public var name: String?
     @NSManaged public var type_long: String?
     @NSManaged public var type_nr: Int64
     @NSManaged public var type_short: String?
 */
    
    enum CodingKeys: String, CodingKey {
       case date
       case id
       case mensa_id
       case name
       case type_long
       case type_nr
       case type_short
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let date = try container.decode(Date.self, forKey: .date)
        let id = try container.decode(Int64.self, forKey: .id)
        let mensa_id = try container.decode(Int64.self, forKey: .mensa_id)
        let name = try container.decode(String.self, forKey: .name)
        let type_long = try container.decode(String.self, forKey: .type_long)
        let type_nr = try container.decode(Int64.self, forKey: .type_nr)
        let type_short = try container.decode(String.self, forKey: .type_short)
        
        self.init(entity: Menu.entity(), insertInto: context)
        self.date = date
        self.id = id
        self.mensa_id = mensa_id
        self.name = name
        self.type_long = type_long
        self.type_nr = type_nr
        self.type_short = type_short
    }
}
