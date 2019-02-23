//
//  Price.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/23/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

@objc class Price: NSManagedObject, Entity {
    
    /*
 
 */
    
    /*
    @NSManaged public var person_typ: String?
    @NSManaged public var preis: NSDecimalNumber?
    @NSManaged public var type_long: String?
    @NSManaged public var type_nr: Int64
    @NSManaged public var type_short: String?
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
        let preis = try container.decode(Decimal.self, forKey: .preis)
        let type_long = try container.decode(String.self, forKey: .type_long)
        let type_nr = try container.decode(Int64.self, forKey: .type_nr)
        let type_short = try container.decode(String.self, forKey: .type_short)
        
        self.init(entity: Menu.entity(), insertInto: context)
        self.person_typ = person_typ
        self.preis = NSDecimalNumber(decimal: preis)
        self.type_long = type_long
        self.type_nr = type_nr
        self.type_short = type_short
    }
}
