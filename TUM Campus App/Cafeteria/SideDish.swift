//
//  SideDish.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/23/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData


class SideDish: NSManagedObject, Entity {
    
    /*
     {
     "mensa_id": "423",
     "date": "2019-02-27",
     "name": "Schoko-Mango-Triffle",
     "type_short": "akt",
     "type_long": "Aktion"
     }
 */
    
    /*
     @NSManaged public var date: Date?
     @NSManaged public var mensa_id: Int64
     @NSManaged public var name: String?
     @NSManaged public var type_long: String?
     @NSManaged public var type_short: String?
 */
    
    enum CodingKeys: String, CodingKey {
        case date
        case mensa_id
        case name
        case type_long
        case type_short
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let date = try container.decode(Date.self, forKey: .date)
        let mensa_id_string = try container.decode(String.self, forKey: .mensa_id)
        guard let mensa_id = Int64(mensa_id_string) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for mensa_id could not be converted to Int64"))
        }
        let name = try container.decode(String.self, forKey: .name)
        let type_long = try container.decode(String.self, forKey: .type_long)
        let type_short = try container.decode(String.self, forKey: .type_short)
        
        let cafeteriaFetchRequest: NSFetchRequest<Cafeteria> = Cafeteria.fetchRequest()
        cafeteriaFetchRequest.predicate = NSPredicate(format: "\(Cafeteria.CodingKeys.id.rawValue) == %d", mensa_id)
        let cafeteria = try context.fetch(cafeteriaFetchRequest).first
        
        self.init(entity: SideDish.entity(), insertInto: context)
        self.date = date
        self.mensa_id = mensa_id
        self.name = name
        self.type_long = type_long
        self.type_short = type_short
        self.cafeteria = cafeteria
    }
    
}
