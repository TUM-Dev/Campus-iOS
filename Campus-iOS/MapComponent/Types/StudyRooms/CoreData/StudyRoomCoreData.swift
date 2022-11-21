//
//  StudyRoomCoreData.swift
//  Campus-iOS
//
//  Created by David Lin on 17.11.22.
//

import Foundation
import CoreData

class StudyRoomCoreData: NSManagedObject {
    
    static var all: NSFetchRequest<StudyRoomCoreData> {
        let request = StudyRoomCoreData.fetchRequest()
        request.sortDescriptors = []
        return request
    }
    
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
    
    enum DecoderConfigurationError: Error {
      case missingManagedObjectContext
    }
    
//    required convenience init(from decoder: Decoder) throws {
//        guard let managedObjectContext = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext,
//                let entity = NSEntityDescription.entity(forEntityName: "StudyRoomCoreData", in: managedObjectContext) else {
//              throw DecoderConfigurationError.missingManagedObjectContext
//        }
//
//        self.init(entity: entity, insertInto: managedObjectContext)
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let occupiedFrom = try container.decode(String.self, forKey: .occupiedFrom)
//        let occupiedUntil = try container.decode(String.self, forKey: .occupiedUntil)
//        let occupiedBy = try container.decode(String.self, forKey: .occupiedBy)
//        let occupiedFor = try container.decode(Int64.self, forKey: .occupiedFor)
//        let occupiedIn = try container.decode(Int64.self, forKey: .occupiedIn)
//        let buildingCode = try container.decode(String.self, forKey: .buildingCode)
//        let buildingName = try container.decode(String.self, forKey: .buildingName)
//        let buildingNumber = try container.decode(Int64.self, forKey: .buildingNumber)
//        let code = try container.decode(String.self, forKey: .code)
//        let name = try container.decode(String.self, forKey: .name)
//        let id = try container.decode(Int64.self, forKey: .id)
//        let raum_nr_architekt = try container.decode(String.self, forKey: .raum_nr_architekt)
//        let number = try container.decode(String.self, forKey: .number)
//        let res_nr = try container.decode(Int64.self, forKey: .res_nr)
//        let status = try container.decode(String.self, forKey: .status)
//        let attributes = try container.decode([StudyRoomAttribute].self, forKey: .attributes)
//
//        self.occupiedFrom = occupiedFrom
//        self.occupiedUntil = occupiedUntil
//        self.occupiedBy = occupiedBy
//        self.occupiedFor = occupiedFor
//        self.occupiedIn = occupiedIn
//        self.buildingCode = buildingCode
//        self.buildingName = buildingName
//        self.buildingNumber = buildingNumber
//        self.code = code
//        self.name = name
//        self.id = id
//        self.raum_nr_architekt = raum_nr_architekt
//        self.number = number
//        self.res_nr = res_nr
//        self.status = status
//        self.attributes = attributes as NSObject
//    }
    
}
