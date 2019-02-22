//
//  Profile.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/22/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

@objc class Profile: NSManagedObject, Entity {
    
    /*
     <row>
        <kennung>ga94zuh</kennung>
        <vorname>Tim</vorname>
        <familienname>Gymnich</familienname>
        <obfuscated_id>3*C551462A7E3AD2CA</obfuscated_id>
        <obfuscated_ids>
            <studierende>3*C551462A7E3AD2CA</studierende>
            <bedienstete isnull="true"></bedienstete>
            <extern isnull="true"></extern>
        </obfuscated_ids>
     </row>
 */
    
    /*
     @NSManaged public var familienname: String?
     @NSManaged public var kennung: String?
     @NSManaged public var obfuscated_id: String?
     @NSManaged public var obfuscated_id_bedienstete: String?
     @NSManaged public var obfuscated_id_extern: String?
     @NSManaged public var obfuscated_id_studierende: String?
     @NSManaged public var vorname: String?
 */
    
    enum CodingKeys: String, CodingKey {
        case familienname
        case kennung
        case obfuscated_id
        case obfuscated_id_bedienstete
        case obfuscated_id_extern
        case obfuscated_id_studierende
        case vorname
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
        let familienname = try container.decode(String.self, forKey: .familienname)
        let kennung = try container.decode(String.self, forKey: .kennung)
        let obfuscated_id = try container.decode(String.self, forKey: .obfuscated_id)
        let obfuscated_id_bedienstete = try container.decode(String.self, forKey: .obfuscated_id_bedienstete)
        let obfuscated_id_extern = try container.decode(String.self, forKey: .obfuscated_id_extern)
        let obfuscated_id_studierende = try container.decode(String.self, forKey: .obfuscated_id_studierende)
        let vorname = try container.decode(String.self, forKey: .vorname)
        
        self.init(entity: Profile.entity(), insertInto: context)
        self.familienname = familienname
        self.kennung = kennung
        self.obfuscated_id = obfuscated_id
        self.obfuscated_id_bedienstete = obfuscated_id_bedienstete
        self.obfuscated_id_extern = obfuscated_id_extern
        self.obfuscated_id_studierende = obfuscated_id_studierende
        self.vorname = vorname
    }
    
}
