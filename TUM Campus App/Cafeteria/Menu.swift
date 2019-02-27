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
       case date = "date"
       case id = "id"
       case mensaID = "mensa_id"
       case name = "name"
       case type = "type_long"
       case typeNumber = "type_nr"
       case typeTag = "type_short"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let date = try container.decode(Date.self, forKey: .date)
        let idString = try container.decode(String.self, forKey: .id)
        guard let id = Int64(idString) else {
             throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for id could not be converted to Int64"))
        }
        let mensa_id_string = try container.decode(String.self, forKey: .mensaID)
        guard let mensaID = Int64(mensa_id_string) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for mensa_id could not be converted to Int64"))
        }
        let name = try container.decode(String.self, forKey: .name)
        let type = try container.decode(String.self, forKey: .type)
        let type_nr_string = try container.decode(String.self, forKey: .typeNumber)
        guard let typeNumber = Int64(type_nr_string) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for type_nr could not be converted to Int64"))
        }
        let typeTag = try container.decode(String.self, forKey: .typeTag)
        
        let cafeteriaFetchRequest: NSFetchRequest<Cafeteria> = Cafeteria.fetchRequest()
        cafeteriaFetchRequest.predicate = NSPredicate(format: "%K == %d", #keyPath(Cafeteria.id) , mensaID)
        let cafeteria = try context.fetch(cafeteriaFetchRequest).first
        
        let priceFetchRequest: NSFetchRequest<MenuPrice> = MenuPrice.fetchRequest()
        priceFetchRequest.predicate = NSPredicate(format: "%K == %d", #keyPath(MenuPrice.typeNumber), typeNumber)
        let prices = try context.fetch(priceFetchRequest)
        
        self.init(entity: Menu.entity(), insertInto: context)
        self.date = date
        self.id = id
        self.mensaID = mensaID
        self.name = name
        self.type = type
        self.typeNumber = typeNumber
        self.typeTag = typeTag
        self.cafeteria = cafeteria
        self.price = NSSet(array: prices)
    }
}
