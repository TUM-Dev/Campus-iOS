//
//  Price.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/23/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

@objc final class MenuPrice: NSManagedObject, Entity {
    
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
       case personType = "person_typ"
       case price = "preis"
       case type = "type_long"
       case typeNumber = "type_nr"
       case typeTag = "type_short"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let personType = try container.decode(String.self, forKey: .personType)
        let priceString = try container.decode(String.self, forKey: .price)
        guard let price = Decimal(string: priceString) else {
            throw DecodingError.typeMismatch(Decimal.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for preis could not be converted to Decimal"))
        }
        let type = try container.decode(String.self, forKey: .type)
        let typeNumberString = try container.decode(String.self, forKey: .typeNumber)
        guard let typeNumber = Int64(typeNumberString) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for type_nr could not be converted to Int64"))
        }
        let typeTag = try container.decode(String.self, forKey: .typeTag)
        
        let menuFetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
        menuFetchRequest.predicate = NSPredicate(format: "%K == %d", #keyPath(Menu.typeNumber), typeNumber)
        let menus = try context.fetch(menuFetchRequest)

        self.init(entity: MenuPrice.entity(), insertInto: context)
        self.personType = personType
        self.price = NSDecimalNumber(decimal: price)
        self.type = type
        self.typeNumber = typeNumber
        self.typeTag = typeTag
        self.menus = NSSet(array: menus)
    }
}
