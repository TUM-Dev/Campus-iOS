//
//  Tuition.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/22/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import CoreData


class TuitionAPIResponse: Decodable {
    var fees: [Tuition]
    
    enum CodingKeys: String, CodingKey {
        case fees = "row"
    }
}


@objc final class Tuition: NSManagedObject, Entity {
    
    /*
     <row>
     <soll>0</soll>
     <frist>2019-02-15</frist>
     <semester_bezeichnung>Sommersemester 2019</semester_bezeichnung>
     <semester_id>19S</semester_id>
     </row>
 */
    
    /*
     @NSManaged public var frist: Date?
     @NSManaged public var semester_bezeichnung: String?
     @NSManaged public var semester_id: String?
     @NSManaged public var soll: Int64
 */
    
    enum CodingKeys: String, CodingKey {
       case frist
       case semester_bezeichnung
       case semester_id
       case soll
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let frist = try container.decode(Date.self, forKey: .frist)
        let semester_bezeichnung = try container.decode(String.self, forKey: .semester_bezeichnung)
        let semester_id = try container.decode(String.self, forKey: .semester_id)
        let soll_string = try container.decode(String.self, forKey: .soll)
        guard let soll = Int64(soll_string) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for soll could not be converted to Int64"))
        }
        
        self.init(entity: Tuition.entity(), insertInto: context)
        self.frist = frist
        self.semester_bezeichnung = semester_bezeichnung
        self.semester_id = semester_id
        self.soll = soll
    }
    
}
