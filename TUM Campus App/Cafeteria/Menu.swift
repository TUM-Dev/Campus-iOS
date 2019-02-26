//
//  Menu.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/23/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

@objc final class Menu: NSManagedObject, Entity {
    
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
        let idString = try container.decode(String.self, forKey: .id)
        guard let id = Int64(idString) else {
             throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for id could not be converted to Int64"))
        }
        let mensa_id_string = try container.decode(String.self, forKey: .mensa_id)
        guard let mensa_id = Int64(mensa_id_string) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for mensa_id could not be converted to Int64"))
        }
        let name = try container.decode(String.self, forKey: .name)
        let type_long = try container.decode(String.self, forKey: .type_long)
        let type_nr_string = try container.decode(String.self, forKey: .type_nr)
        guard let type_nr = Int64(type_nr_string) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for type_nr could not be converted to Int64"))
        }
        let type_short = try container.decode(String.self, forKey: .type_short)
        
        let cafeteriaFetchRequest: NSFetchRequest<Cafeteria> = Cafeteria.fetchRequest()
        cafeteriaFetchRequest.predicate = NSPredicate(format: "\(Cafeteria.CodingKeys.id.rawValue) == %d", mensa_id)
        let cafeteria = try context.fetch(cafeteriaFetchRequest).first
        
        let priceFetchRequest: NSFetchRequest<Price> = Price.fetchRequest()
        priceFetchRequest.predicate = NSPredicate(format: "\(Price.CodingKeys.type_nr.rawValue) == %d", type_nr)
        let prices = try context.fetch(priceFetchRequest)
        
        self.init(entity: Menu.entity(), insertInto: context)
        self.date = date
        self.id = id
        self.mensa_id = mensa_id
        self.name = name
        self.type_long = type_long
        self.type_nr = type_nr
        self.type_short = type_short
        self.cafeteria = cafeteria
        self.price = NSSet(array: prices)
    }
}
