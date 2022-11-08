//
//  APIConstants.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation
import CoreData

// As XMLDecoding is complete BS
//typealias Grade = GradeComponents.Row

class Grade: NSManagedObject, Decodable {
    
    static var all: NSFetchRequest<Grade> {
        let request = Grade.fetchRequest()
        request.sortDescriptors = []
        return request
    }
    
    var modusShort: String {
        switch self.modus {
        case "Schriftlich": return "Written".localized
        case "Beurteilt/immanenter Prüfungscharakter": return "Graded".localized
        case "Schriftlich und Mündlich": return "Written/Oral".localized
        case "Mündlich": return "Oral".localized
        default: return "Unknown".localized
        }
    }
    
    public var id: String {
        guard let date = date, let lvNumber = lvNumber else {
            return UUID().uuidString
        }
        
        return date.formatted() + "-" + lvNumber
    }

    enum CodingKeys: String, CodingKey {
        case date = "datum"
        case lvNumber = "lv_nummer"
        case semester = "lv_semester"
        case title = "lv_titel"
        case examiner = "pruefer_nachname"
        case grade = "uninotenamekurz"
        case examType = "exam_typ_name"
        case modus = "modus"
        case studyID = "studienidentifikator"
        case studyDesignation = "studienbezeichnung"
        case studyNumber = "st_studium_nr"
    }

    // https://www.donnywals.com/using-codable-with-core-data-and-nsmanagedobject/
    required convenience public init(from decoder: Decoder) throws {
        guard let managedObjectContext = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext,
                let entity = NSEntityDescription.entity(forEntityName: "Grade", in: managedObjectContext) else {
              throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Extra handelling of the date decoding
        do {
            date = try container.decode(Date.self, forKey: .date)
        } catch {
            date = .now
        }
        lvNumber = try container.decode(String.self, forKey: .lvNumber)
        semester = try container.decode(String.self, forKey: .semester)
        title = try container.decode(String.self, forKey: .title)
        examiner = try container.decode(String.self, forKey: .examiner)
        grade = try container.decode(String.self, forKey: .grade)
        examType = try container.decode(String.self, forKey: .examType)
        modus = try container.decode(String.self, forKey: .modus)
        studyID = try container.decode(String.self, forKey: .studyID)
        studyDesignation = try container.decode(String.self, forKey: .studyDesignation)
        studyNumber = try container.decode(Int64.self, forKey: .studyNumber)

        print("Title: \(title ?? "NO TITLE")")
    }
    
    func getGradeString() -> String {
        if let gradeString = grade {
            return gradeString.isEmpty ? "tbd" : gradeString
        } else {
            return "n.a"
        }
    }
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

//enum GradeComponents {
//    struct RowSet: Decodable {
//        public var row: [Row]
//    }
//
//    struct Row: Identifiable {
//        // Create own identifier as there isn't one
//        public var id: String {
//            date.formatted() + "-" + lvNumber
//        }
//        public var date: Date
//        public var lvNumber: String
//        public var semester: String
//        public var title: String
//        public var examiner: String
//        public var grade: String
//        public var examType: String
//        public var modus: String
//        public var studyID: String
//        public var studyDesignation: String
//        public var studyNumber: UInt64
//
//        var modusShort: String {
//            switch self.modus {
//            case "Schriftlich": return "Written".localized
//            case "Beurteilt/immanenter Prüfungscharakter": return "Graded".localized
//            case "Schriftlich und Mündlich": return "Written/Oral".localized
//            case "Mündlich": return "Oral".localized
//            default: return "Unknown".localized
//            }
//        }
//
//        enum CodingKeys: String, CodingKey {
//            case date = "datum"
//            case lvNumber = "lv_nummer"
//            case semester = "lv_semester"
//            case title = "lv_titel"
//            case examiner = "pruefer_nachname"
//            case grade = "uninotenamekurz"
//            case examType = "exam_typ_name"
//            case modus = "modus"
//            case studyID = "studienidentifikator"
//            case studyDesignation = "studienbezeichnung"
//            case studyNumber = "st_studium_nr"
//        }
//    }
//}
//
//extension Grade: Decodable {
//    // Need for a custom Decoder implementation as the XMLCoder library isn't able to handle missing Date properties and the entire decoding fails in case of a non-existing Date value
//    init(from decoder: Decoder) throws {
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
//        studyNumber = try container.decode(UInt64.self, forKey: .studyNumber)
//    }
//}

extension Grade {
//    static var grade1 = Grade(context: PersistenceController.shared.container.viewContext)
//    grade1.date = .now
//    grade1.lvNumber = "IN0008"
//    grade1.semester = "21W"
//    grade1.title = "Grundlagen: Datenbanken"
//    grade1.examiner = "Kemper"
//    grade1.grade = "1,3"
//    grade1.examType = "FA"
//    grade1.modus = "Schriftlich"
//    grade1.studyID = "1630 17 030"
//    grade1.studyDesignation = "Informatik"
//    grade1.studyNumber = 947170
//
//    let grade2 = Grade(context: PersistenceController.shared.container.viewContext)
//    grade2.date = .now
//    grade2.lvNumber = "IN0010E"
//    grade2.semester = "21S"
//    grade2.title = "Grundlagen: Rechnernetze und verteilte Systeme"
//    grade2.examiner = "Carle"
//    grade2.grade = "2,7"
//    grade2.examType = "FA"
//    grade2.modus = "Schriftlich"
//    grade2.studyID = "1630 17 030"
//    grade2.studyDesignation = "Informatik"
//    grade2.studyNumber = 947170
//
//    let grade3 = Grade(context: PersistenceController.shared.container.viewContext)
//    grade3.date = .now
//    grade3.lvNumber = "IN0010E"
//    grade3.semester = "20W"
//    grade3.title = "Einführung in die Informatik 1"
//    grade3.examiner = "Seidl"
//    grade3.grade = "2,3"
//    grade3.examType = "FA"
//    grade3.modus = "Schriftlich"
//    grade3.studyID = "1630 17 030"
//    grade3.studyDesignation = "Informatik"
//    grade3.studyNumber = 947170
//
//    let grade4 = Grade(context: PersistenceController.shared.container.viewContext)
//    grade4.date = .now
//    grade4.lvNumber = "IN0002"
//    grade4.semester = "20W"
//    grade4.title = "Praktikum Grundlagen der Programmierung"
//    grade4.examiner = "Seidl"
//    grade4.grade = "1,7"
//    grade4.examType = "FA"
//    grade4.modus = "Schriftlich"
//    grade4.studyID = "1630 17 030"
//    grade4.studyDesignation = "Informatik"
//    grade4.studyNumber = 947170
//
//    let grade5 = Grade(context: PersistenceController.shared.container.viewContext)
//    grade5.date = .now
//    grade5.lvNumber = "IN0006"
//    grade5.semester = "21S"
//    grade5.title = "Einführung in die Softwaretechnik"
//    grade5.examiner = "Brügge"
//    grade5.grade = "2,7"
//    grade5.examType = "FA"
//    grade5.modus = "Schriftlich"
//    grade5.studyID = "1630 17 030"
//    grade5.studyDesignation = "Informatik"
//    grade5.studyNumber = 947170
//
//    let grade6 = Grade(context: PersistenceController.shared.container.viewContext)
//    grade6.date = .now
//    grade6.lvNumber = "IN4741"
//    grade6.semester = "17W"
//    grade6.title = "Seminar Teaching iOS"
//    grade6.examiner = "Einführung in die Softwaretechnik"
//    grade6.grade = "Brügge"
//    grade6.examType = "2,7"
//    grade6.modus = "FA"
//    grade6.studyID = "Schriftlich"
//    grade6.studyDesignation = "1630 17 030"
//    grade6.studyNumber = 947170
    
    
    
    static let dummyData21W: [Grade] = [/*grade1*/]
    
    static let dummyData21S: [Grade] = [/*grade2, grade5*/]
    
    static let dummyData20W: [Grade] = [/*grade3, grade5*/]
    
    static var dummyDataAll: [Grade] = dummyData21W + dummyData21S + dummyData20W
    
    static let dummyData: [Grade] = [/*grade6, grade6, grade6*/]
}

