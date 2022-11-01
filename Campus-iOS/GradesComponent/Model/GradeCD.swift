////
////  GradeCoreData.swift
////  Campus-iOS
////
////  Created by David Lin on 24.10.22.
////
//
//import Foundation
//import CoreData
//
//class GradeCD: NSManagedObject, Decodable {
//
//    enum CodingKeys: String, CodingKey {
//        case date = "datum"
//        case lvNumber = "lv_nummer"
//        case semester = "lv_semester"
//        case title = "lv_titel"
//        case examiner = "pruefer_nachname"
//        case grade = "uninotenamekurz"
//        case examType = "exam_typ_name"
//        case modus = "modus"
//        case studyID = "studienidentifikator"
//        case studyDesignation = "studienbezeichnung"
//        case studyNumber = "st_studium_nr"
//    }
//    
//    enum DecoderConfigurationError: Error {
//      case missingManagedObjectContext
//    }
//
//    
//    required convenience public init(from decoder: Decoder) throws {
//        guard let managedObjectContext = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext,
//                let entity = NSEntityDescription.entity(forEntityName: "GradeCD", in: managedObjectContext) else {
//              throw DecoderConfigurationError.missingManagedObjectContext
//        }
//        
//        print("INIT")
//        self.init(entity: entity, insertInto: managedObjectContext)
//        
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        // Extra handelling of the date decoding
//        do {
//            date = try container.decode(Date.self, forKey: .date)
//        } catch {
//            date = .now
//        }
//        lvNumber = try container.decode(String.self, forKey: .lvNumber)
//        semester = try container.decode(String.self, forKey: .semester)
//        title = try container.decode(String.self, forKey: .title)
//        examiner = try container.decode(String.self, forKey: .examiner)
//        grade = try container.decode(String.self, forKey: .grade)
//        examType = try container.decode(String.self, forKey: .examType)
//        modus = try container.decode(String.self, forKey: .modus)
//        studyID = try container.decode(String.self, forKey: .studyID)
//        studyDesignation = try container.decode(String.self, forKey: .studyDesignation)
//        studyNumber = try container.decode(Int64.self, forKey: .studyNumber)
//
//        print("Title: \(title ?? "NO TITLE")")
//    }
//}
//
//extension CodingUserInfoKey {
//    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
//}
