//
//  Profile.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.02.22.
//

import Foundation

struct Profile: Decodable, Entity {
    let firstname: String?
    let obfuscatedID: String?
    let obfuscatedIDEmployee: String?
    let obfuscatedIDExtern: String?
    let obfuscatedIDStudent: String?
    let surname: String?
    let tumID: String?

    var personGroup: String? {
        let split = obfuscatedID?.split(separator: "*")
        guard let group = split?.first, split?.count == 2 else { return nil }
        return String(group)
    }
    var id: String? {
        let split = obfuscatedID?.split(separator: "*")
        guard let id = split?.last, split?.count == 2 else { return nil }
        return String(id)
    }
    
    var fullName: String {
        "\(self.firstname?.appending(" ") ?? "")\(self.surname?.appending(" ") ?? "")"
    }
    
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
    
    enum CodingKeys: String, CodingKey {
        case surname = "familienname"
        case tumID = "kennung"
        case obfuscatedID = "obfuscated_id"
        case obfuscatedIDEmployee = "obfuscated_id_bedienstete"
        case obfuscatedIDExtern = "obfuscated_id_extern"
        case obfuscatedIDStudent = "obfuscated_id_studierende"
        case firstname = "vorname"
    }
    
    var role: Role {
        if obfuscatedIDStudent != nil {
            return .student
        } else if obfuscatedIDEmployee != nil {
            return .employee
        } else {
            return .extern
        }
    }
    
    init(firstname: String?, surname: String?, tumId: String?, obfuscatedID: String?, obfuscatedIDEmployee: String?, obfuscatedIDExtern: String?, obfuscatedIDStudent: String?) {
        self.firstname = firstname
        self.surname = surname
        self.obfuscatedID = obfuscatedID
        self.obfuscatedIDEmployee = obfuscatedIDEmployee
        self.obfuscatedIDExtern = obfuscatedIDExtern
        self.obfuscatedIDStudent = obfuscatedIDStudent
        self.tumID = tumId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let surname = try container.decode(String.self, forKey: .surname)
        let tumID = try container.decode(String.self, forKey: .tumID)
        let obfuscatedID = try container.decode(String.self, forKey: .obfuscatedID)
        let obfuscatedIDEmployee = try container.decodeIfPresent(String.self, forKey: .obfuscatedIDEmployee)
        let obfuscatedIDExtern = try container.decodeIfPresent(String.self, forKey: .obfuscatedIDExtern)
        let obfuscatedIDStudent = try container.decodeIfPresent(String.self, forKey: .obfuscatedIDStudent)
        let firstname = try container.decode(String.self, forKey: .firstname)
        
        self.surname = surname
        self.tumID = tumID
        self.obfuscatedID = obfuscatedID
        self.obfuscatedIDEmployee = obfuscatedIDEmployee
        self.obfuscatedIDExtern = obfuscatedIDExtern
        self.obfuscatedIDStudent = obfuscatedIDStudent
        self.firstname = firstname
    }
}
