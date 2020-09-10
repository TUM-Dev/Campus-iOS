//
//  Grade.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/21/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import CoreData

@objc final class Grade: NSManagedObject, Identifiable, Entity {
    @NSManaged public var date: Date?
    @NSManaged public var examiner: String?
    @NSManaged public var examType: String?
    @NSManaged public var grade: String?
    @NSManaged public var lvNumber: String?
    @NSManaged public var modus: String?
    @NSManaged public var semester: String?
    @NSManaged public var studyDesignation: String?
    @NSManaged public var studyID: String?
    @NSManaged public var studyNumber: Int64
    @NSManaged public var title: String?
    @NSManaged public var lecture: Lecture?
    
    /*
 
     <row>
        <pv_kand_nr isnull="true"></pv_kand_nr>
        <datum>2017-10-19</datum>
        <lv_nummer>IN4741</lv_nummer>
        <lv_semester>17W</lv_semester>
        <lv_titel>Seminar Teaching iOS</lv_titel>
        <pruefer_nachname>Brügge</pruefer_nachname>
        <uninotenamekurz>1,0</uninotenamekurz>
        <exam_typ_name>FA</exam_typ_name>
        <modus>Beurteilt/immanenter Prüfungscharakter</modus>
        <studienidentifikator>1630 17 030</studienidentifikator>
        <studienbezeichnung>Informatik</studienbezeichnung>
        <st_studium_nr>947170</st_studium_nr>
        <lv_credits isnull="true"></lv_credits>
     </row>
 */
    static let sectionNameKeyPath: KeyPath<Grade, String?>? = \Grade.semester
    
    enum CodingKeys: String, CodingKey {
        case date = "datum"
        case examType = "exam_typ_name"
        case lvNumber = "lv_nummer"
        case semester = "lv_semester"
        case title = "lv_titel"
        case modus = "modus"
        case examiner = "pruefer_nachname"
        case studyNumber = "st_studium_nr"
        case studyDesignation = "studienbezeichnung"
        case studyID = "studienidentifikator"
        case grade = "uninotenamekurz"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let date = try container.decode(Date.self, forKey: .date)
        let examType = try container.decode(String.self, forKey: .examType)
        let lvNumber = try container.decode(String.self, forKey: .lvNumber)
        let semester = try container.decode(String.self, forKey: .semester)
        let title = try container.decode(String.self, forKey: .title)
        let modus = try container.decode(String.self, forKey: .modus)
        let examiner = try container.decode(String.self, forKey: .examiner)
        let studyNumber = try container.decode(Int64.self, forKey: .studyNumber)
        let studyDesignation = try container.decode(String.self, forKey: .studyDesignation)
        let studyID = try container.decode(String.self, forKey: .studyID)
        let grade = try container.decode(String.self, forKey: .grade)
        
        let lectureFetchRequest: NSFetchRequest<Lecture> = Lecture.fetchRequest()
        lectureFetchRequest.predicate = NSPredicate(format: "%K CONTAINS %@", #keyPath(Lecture.title) , title)
        let lecture = try context.fetch(lectureFetchRequest).first

        self.init(entity: Grade.entity(), insertInto: context)
        self.date = date
        self.examType = examType
        self.lvNumber = lvNumber
        self.semester = semester
        self.title = title
        self.modus = modus
        self.examiner = examiner
        self.studyNumber = studyNumber
        self.studyDesignation = studyDesignation
        self.studyID = studyID
        self.grade = grade
        self.lecture = lecture
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Grade> {
        return NSFetchRequest<Grade>(entityName: "Grade")
    }

}
