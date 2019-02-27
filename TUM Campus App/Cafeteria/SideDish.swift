//
//  SideDish.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/23/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData


@objc final class SideDish: NSManagedObject, Entity {
    
    /*
     {
     "mensa_id": "423",
     "date": "2019-02-27",
     "name": "Schoko-Mango-Triffle",
     "type_short": "akt",
     "type_long": "Aktion"
     }
 */
    
    enum CodingKeys: String, CodingKey {
        case date
        case mensaID
        case name
        case type
        case typeTag
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let date = try container.decode(Date.self, forKey: .date)
        let mensa_id_string = try container.decode(String.self, forKey: .mensaID)
        guard let mensaID = Int64(mensa_id_string) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for mensa_id could not be converted to Int64"))
        }
        let name = try container.decode(String.self, forKey: .name)
        let type = try container.decode(String.self, forKey: .type)
        let typeTag = try container.decode(String.self, forKey: .typeTag)
        
        let cafeteriaFetchRequest: NSFetchRequest<Cafeteria> = Cafeteria.fetchRequest()
        cafeteriaFetchRequest.predicate = NSPredicate(format: "id == %d", mensaID)
        let cafeteria = try context.fetch(cafeteriaFetchRequest).first
        
        self.init(entity: SideDish.entity(), insertInto: context)
        self.date = date
        self.mensaID = mensaID
        self.name = name
        self.type = type
        self.typeTag = typeTag
        self.cafeteria = cafeteria
    }
    
}
