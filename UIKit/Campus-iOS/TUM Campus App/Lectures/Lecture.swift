//
//  Lecture.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/19/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

@objc final class Lecture: NSManagedObject, Identifiable, Entity {
    @NSManaged public var duration: NSDecimalNumber?
    @NSManaged public var eventType: String?
    @NSManaged public var eventTypeTag: String?
    @NSManaged public var id: Int64
    @NSManaged public var lvNumber: Int64
    @NSManaged public var organisation: String?
    @NSManaged public var organisationNumber: Int64
    @NSManaged public var organisationTag: String?
    @NSManaged public var semester: String?
    @NSManaged public var semesterID: String?
    @NSManaged public var semesterType: String?
    @NSManaged public var semesterYear: String?
    @NSManaged public var speaker: String?
    @NSManaged public var stp_sp_sst: String?
    @NSManaged public var title: String?
    @NSManaged public var grade: Grade?
    
    /*
     <row>
        <stp_sp_nr>950396293</stp_sp_nr>
        <stp_lv_nr>90049615</stp_lv_nr>
        <stp_sp_titel>Practical course - Program optimization with LLVM (IN0012, IN2106, IN4236)</stp_sp_titel>
        <dauer_info>6</dauer_info>
        <stp_sp_sst>6</stp_sp_sst>
        <stp_lv_art_name>Praktikum</stp_lv_art_name>
        <stp_lv_art_kurz>PR</stp_lv_art_kurz>
        <sj_name>2018/19</sj_name>
        <semester>W</semester>
        <semester_name>Wintersemester 2018/19</semester_name>
        <semester_id>18W</semester_id>
        <org_nr_betreut>15427</org_nr_betreut>
        <org_name_betreut>Informatik 2 - Lehrstuhl für Sprachen und Beschreibungsstrukturen in der Informatik (Prof. Seidl)</org_name_betreut>
        <org_kennung_betreut>TUINI02</org_kennung_betreut>
        <vortragende_mitwirkende>Seidl H [L], Petter M</vortragende_mitwirkende>
     </row>
 */
    
    enum CodingKeys: String, CodingKey {
        case id = "stp_sp_nr"
        case lvNumber = "stp_lv_nr"
        case title = "stp_sp_titel"
        case duration = "dauer_info"
        case stp_sp_sst = "stp_sp_sst"
        case eventType = "stp_lv_art_name"
        case eventTypeTag = "stp_lv_art_kurz"
        case semesterYear = "sj_name"
        case semesterType = "semester"
        case semester = "semester_name"
        case semesterID = "semester_id"
        case organisationNumber = "org_nr_betreut"
        case organisation = "org_name_betreut"
        case organisationTag = "org_kennung_betreut"
        case speaker = "vortragende_mitwirkende"
    }
    
    static let sectionNameKeyPath: KeyPath<Lecture, String?>? = \Lecture.semesterID
    
    required convenience init(from decoder: Decoder) throws {
        let context = decoder.userInfo[.context] as? NSManagedObjectContext
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let duration = try container.decode(Decimal.self, forKey: .duration)
        let organisationTag = try container.decode(String.self, forKey: .organisationTag)
        let organisation = try container.decode(String.self, forKey: .organisation)
        let organisationNumber = try container.decode(Int64.self, forKey: .organisationNumber)
        let semesterType = try container.decode(String.self, forKey: .semesterType)
        let semesterID = try container.decode(String.self, forKey: .semesterID)
        let semester = try container.decode(String.self, forKey: .semester)
        let semesterYear = try container.decode(String.self, forKey: .semesterYear)
        let eventTypeTag = try container.decode(String.self, forKey: .eventTypeTag)
        let eventType = try container.decode(String.self, forKey: .eventType)
        let lvNumber = try container.decode(Int64.self, forKey: .lvNumber)
        let id = try container.decode(Int64.self, forKey: .id)
        let stp_sp_sst = try container.decode(String.self, forKey: .stp_sp_sst)
        let title = try container.decode(String.self, forKey: .title)
        let speaker = try container.decode(String.self, forKey: .speaker)
        
        let gradeFetchRequest: NSFetchRequest<Grade> = Grade.fetchRequest()
        gradeFetchRequest.predicate = NSPredicate(format: "%K CONTAINS %@", #keyPath(Grade.title) , title)
        let grade = try context?.fetch(gradeFetchRequest).first

        self.init(entity: Lecture.entity(), insertInto: context)
        self.duration = NSDecimalNumber(decimal: duration)
        self.organisationTag = organisationTag
        self.organisation = organisation
        self.organisationNumber = organisationNumber
        self.semesterType = semesterType
        self.semesterID = semesterID
        self.semester = semester
        self.semesterYear = semesterYear
        self.eventTypeTag = eventTypeTag
        self.eventType = eventType
        self.lvNumber = lvNumber
        self.id = id
        self.stp_sp_sst = stp_sp_sst
        self.title = title
        self.speaker = speaker
        self.grade = grade
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lecture> {
        return NSFetchRequest<Lecture>(entityName: "Lecture")
    }

}
