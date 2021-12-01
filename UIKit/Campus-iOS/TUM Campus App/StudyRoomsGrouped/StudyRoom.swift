//
//  StudyRoom.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/24/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

@objc final class StudyRoom: NSManagedObject, Entity {
    @NSManaged public var buildingCode: String?
    @NSManaged public var buildingName: String?
    @NSManaged public var buildingNumber: Int64
    @NSManaged public var code: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var number: String?
    @NSManaged public var occupiedBy: String?
    @NSManaged public var occupiedFor: Int64
    @NSManaged public var occupiedFrom: String?
    @NSManaged public var occupiedIn: Int64
    @NSManaged public var occupiedUntil: String?
    @NSManaged public var raum_nr_architekt: String?
    @NSManaged public var res_nr: Int64
    @NSManaged public var status: String?
    @NSManaged public var attributes: NSSet?
    @NSManaged public var group: StudyRoomGroup?

    @objc(addAttributesObject:)
    @NSManaged public func addToAttributes(_ value: StudyRoomAttribute)

    @objc(removeAttributesObject:)
    @NSManaged public func removeFromAttributes(_ value: StudyRoomAttribute)

    @objc(addAttributes:)
    @NSManaged public func addToAttributes(_ values: NSSet)

    @objc(removeAttributes:)
    @NSManaged public func removeFromAttributes(_ values: NSSet)
    
    enum CodingKeys: String, CodingKey {
        case occupiedFrom = "belegung_ab"
        case occupiedUntil = "belegung_bis"
        case occupiedBy = "belegung_durch"
        case occupiedFor = "belegung_fuer"
        case occupiedIn = "belegung_in"
        case buildingCode = "gebaeude_code"
        case buildingName = "gebaeude_name"
        case buildingNumber = "gebaeude_nr"
        case code = "raum_code"
        case name = "raum_name"
        case id = "raum_nr"
        case raum_nr_architekt = "raum_nr_architekt"
        case number = "raum_nummer"
        case res_nr = "res_nr"
        case status = "status"
        case attributes = "attribute"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let occupiedFrom = try container.decode(String.self, forKey: .occupiedFrom)
        let occupiedUntil = try container.decode(String.self, forKey: .occupiedUntil)
        let occupiedBy = try container.decode(String.self, forKey: .occupiedBy)
        let occupiedFor = try container.decode(Int64.self, forKey: .occupiedFor)
        let occupiedIn = try container.decode(Int64.self, forKey: .occupiedIn)
        let buildingCode = try container.decode(String.self, forKey: .buildingCode)
        let buildingName = try container.decode(String.self, forKey: .buildingName)
        let buildingNumber = try container.decode(Int64.self, forKey: .buildingNumber)
        let code = try container.decode(String.self, forKey: .code)
        let name = try container.decode(String.self, forKey: .name)
        let id = try container.decode(Int64.self, forKey: .id)
        let raum_nr_architekt = try container.decode(String.self, forKey: .raum_nr_architekt)
        let number = try container.decode(String.self, forKey: .number)
        let res_nr = try container.decode(Int64.self, forKey: .res_nr)
        let status = try container.decode(String.self, forKey: .status)
        let attributes = try container.decode([StudyRoomAttribute].self, forKey: .attributes)
        
        self.init(entity: StudyRoom.entity(), insertInto: context)
        self.occupiedFrom = occupiedFrom
        self.occupiedUntil = occupiedUntil
        self.occupiedBy = occupiedBy
        self.occupiedFor = occupiedFor
        self.occupiedIn = occupiedIn
        self.buildingCode = buildingCode
        self.buildingName = buildingName
        self.buildingNumber = buildingNumber
        self.code = code
        self.name = name
        self.id = id
        self.raum_nr_architekt = raum_nr_architekt
        self.number = number
        self.res_nr = res_nr
        self.status = status
        self.attributes = NSSet(array: attributes)
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudyRoom> {
        return NSFetchRequest<StudyRoom>(entityName: "StudyRoom")
    }

}
