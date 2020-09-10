//
//  Profile.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/22/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

@objc final class Profile: NSManagedObject, Identifiable, Entity {
    @NSManaged public var firstname: String?
    @NSManaged public var obfuscatedID: String?
    @NSManaged public var obfuscatedIDEmployee: String?
    @NSManaged public var obfuscatedIDExtern: String?
    @NSManaged public var obfuscatedIDStudent: String?
    @NSManaged public var surname: String?
    @NSManaged public var tumID: String?

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
    
    enum Role: String {
        case student = "student"
        case extern = "extern"
        case employee = "employee"

        var localizedDesription: String {
            switch self {
            case .student: return "Student".localized
            case .extern: return "Extern".localized
            case .employee: return "Employee".localized
            }
        }
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
    
    required convenience init(from decoder: Decoder) throws {
        let context = decoder.userInfo[.context] as? NSManagedObjectContext
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let surname = try container.decode(String.self, forKey: .surname)
        let tumID = try container.decode(String.self, forKey: .tumID)
        let obfuscatedID = try container.decode(String.self, forKey: .obfuscatedID)
        let obfuscatedIDEmployee = try container.decodeIfPresent(String.self, forKey: .obfuscatedIDEmployee)
        let obfuscatedIDExtern = try container.decodeIfPresent(String.self, forKey: .obfuscatedIDExtern)
        let obfuscatedIDStudent = try container.decodeIfPresent(String.self, forKey: .obfuscatedIDStudent)
        let firstname = try container.decode(String.self, forKey: .firstname)
        
        self.init(entity: Profile.entity(), insertInto: context)
        self.surname = surname
        self.tumID = tumID
        self.obfuscatedID = obfuscatedID
        self.obfuscatedIDEmployee = obfuscatedIDEmployee
        self.obfuscatedIDExtern = obfuscatedIDExtern
        self.obfuscatedIDStudent = obfuscatedIDStudent
        self.firstname = firstname
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }
    
}
