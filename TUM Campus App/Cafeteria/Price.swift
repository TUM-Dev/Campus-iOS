//
//  Price.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/23/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

@objc final class Price: NSManagedObject, Entity {
    
    /*
     {
        "person_typ": "st",
        "type_short": "tg",
        "type_long": "Tagesgericht 1",
        "type_nr": "1",
        "preis": "1"
     },
 */
    
    enum CodingKeys: String, CodingKey {
       case person_typ
       case preis
       case type_long
       case type_nr
       case type_short
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let person_typ = try container.decode(String.self, forKey: .person_typ)
        let preis_string = try container.decode(String.self, forKey: .preis)
        guard let preis = Decimal(string: preis_string) else {
            throw DecodingError.typeMismatch(Decimal.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for preis could not be converted to Decimal"))
        }
        let type_long = try container.decode(String.self, forKey: .type_long)
        let type_nr_string = try container.decode(String.self, forKey: .type_nr)
        guard let type_nr = Int64(type_nr_string) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for type_nr could not be converted to Int64"))
        }
        let type_short = try container.decode(String.self, forKey: .type_short)
        
        let menuFetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
        menuFetchRequest.predicate = NSPredicate(format: "\(Menu.CodingKeys.type_nr.rawValue) == %d", type_nr)
        let menus = try context.fetch(menuFetchRequest)
        
        self.init(entity: Price.entity(), insertInto: context)
        self.person_typ = person_typ
        self.preis = NSDecimalNumber(decimal: preis)
        self.type_long = type_long
        self.type_nr = type_nr
        self.type_short = type_short
        self.menus = NSSet(array: menus)
    }
}
