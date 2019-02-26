//
//  StudRoom.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/24/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

@objc final class StudyRoom: NSManagedObject, Entity {
    
    enum CodingKeys: String, CodingKey {
        case belegung_ab
        case belegung_bis
        case belegung_durch
        case belegung_fuer
        case belegung_in
        case gebaeude_code
        case gebaeude_name
        case gebaeude_nr
        case raum_code
        case raum_name
        case raum_nr
        case raum_nr_architekt
        case raum_nummer
        case res_nr
        case status
        case attribute
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let belegung_ab = try container.decode(String.self, forKey: .belegung_ab)
        let belegung_bis = try container.decode(String.self, forKey: .belegung_bis)
        let belegung_durch = try container.decode(String.self, forKey: .belegung_durch)
        let belegung_fuer = try container.decode(Int64.self, forKey: .belegung_fuer)
        let belegung_in = try container.decode(Int64.self, forKey: .belegung_in)
        let gebaeude_code = try container.decode(String.self, forKey: .gebaeude_code)
        let gebaeude_name = try container.decode(String.self, forKey: .gebaeude_name)
        let gebaeude_nr = try container.decode(Int64.self, forKey: .gebaeude_nr)
        let raum_code = try container.decode(String.self, forKey: .raum_code)
        let raum_name = try container.decode(String.self, forKey: .raum_name)
        let raum_nr = try container.decode(Int64.self, forKey: .raum_nr)
        let raum_nr_architekt = try container.decode(String.self, forKey: .raum_nr_architekt)
        let raum_nummer = try container.decode(String.self, forKey: .raum_nummer)
        let res_nr = try container.decode(Int64.self, forKey: .res_nr)
        let status = try container.decode(String.self, forKey: .status)
        let attributes = try container.decode([StudyRoomAttribute].self, forKey: .attribute)
        
        self.init(entity: StudyRoom.entity(), insertInto: context)
        self.belegung_ab = belegung_ab
        self.belegung_bis = belegung_bis
        self.belegung_durch = belegung_durch
        self.belegung_fuer = belegung_fuer
        self.belegung_in = belegung_in
        self.gebaeude_code = gebaeude_code
        self.gebaeude_name = gebaeude_name
        self.gebaeude_nr = gebaeude_nr
        self.raum_code = raum_code
        self.raum_name = raum_name
        self.raum_nr = raum_nr
        self.raum_nr_architekt = raum_nr_architekt
        self.raum_nummer = raum_nummer
        self.res_nr = res_nr
        self.status = status
        self.attributes = NSSet(array: attributes)
    }
}
