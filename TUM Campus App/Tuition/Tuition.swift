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
    
    enum CodingKeys: String, CodingKey {
       case deadline = "frist"
       case semester = "semester_bezeichnung"
       case semesterID = "semester_id"
       case amount = "soll"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let deadline = try container.decode(Date.self, forKey: .deadline)
        let semester = try container.decode(String.self, forKey: .semester)
        let semesterID = try container.decode(String.self, forKey: .semesterID)
        let amountString = try container.decode(String.self, forKey: .amount)
        guard let amount = Decimal(string: amountString) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for amount could not be converted to Int64"))
        }
        
        self.init(entity: Tuition.entity(), insertInto: context)
        self.deadline = deadline
        self.semester = semester
        self.semesterID = semesterID
        self.amount = NSDecimalNumber(decimal: amount)
    }
    
}
