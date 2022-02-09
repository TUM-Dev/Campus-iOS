//
//  Tuition.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 07.02.22.
//

import Foundation

struct Tuition: Entity {
    
    var amount: NSDecimalNumber?
    var deadline: Date?
    var semester: String?
    var semesterID: String?
    
    var isOpenAmount: Bool {
        guard let amount = self.amount, amount.isEqual(to: 0) else {
            return true
        }
        return false
    }
    
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
    
    init( deadline: Date?, semester: String?, semesterID: String?, amount: NSDecimalNumber) {
        self.deadline = deadline
        self.semester = semester
        self.semesterID = semesterID
        self.amount = amount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let deadline = try container.decode(Date.self, forKey: .deadline)
        let semester = try container.decode(String.self, forKey: .semester)
        let semesterID = try container.decode(String.self, forKey: .semesterID)
        let amountString = try container.decode(String.self, forKey: .amount)
        let amount = NSDecimalNumber(string: amountString, locale: Locale.init(identifier: "de"))
        if amount == NSDecimalNumber.notANumber {
            throw DecodingError.typeMismatch(NSDecimalNumber.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for amount could not be converted to Decimal."))
        }
        
        self.deadline = deadline
        self.semester = semester
        self.semesterID = semesterID
        self.amount = amount
    }
}
