//
//  Grade.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/21/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import CoreData

// XMLDecoder cannot use [Grade].self so we have to wrap the grades in Grades. This is probably a bug in parsing the root node.
struct GradesAPIResponse: Decodable {
    var grades: [Grade]
    
    enum CodingKeys: String, CodingKey {
        case grades = "row"
    }
}

@objc final class Grade: NSManagedObject, Entity {
    
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
    
    enum CodingKeys: String, CodingKey {
        case datum
        case exam_typ_name
        case lv_nummer
        case lv_semester
        case lv_titel
        case modus
        case pruefer_nachname
        case st_studium_nr
        case studienbezeichnung
        case studienidentifikator
        case uninotenamekurz
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let datum = try container.decode(Date.self, forKey: .datum)
        let exam_typ_name = try container.decode(String.self, forKey: .exam_typ_name)
        let lv_nummer = try container.decode(String.self, forKey: .lv_nummer)
        let lv_semester = try container.decode(String.self, forKey: .lv_semester)
        let lv_titel = try container.decode(String.self, forKey: .lv_titel)
        let modus = try container.decode(String.self, forKey: .modus)
        let pruefer_nachname = try container.decode(String.self, forKey: .pruefer_nachname)
        let st_studium_nr = try container.decode(String.self, forKey: .st_studium_nr)
        let studienbezeichnung = try container.decode(String.self, forKey: .studienbezeichnung)
        let studienidentifikator = try container.decode(String.self, forKey: .studienidentifikator)
        let uninotenamekurz = try container.decode(String.self, forKey: .uninotenamekurz)
        
        let lectureFetchRequest: NSFetchRequest<Lecture> = Lecture.fetchRequest()
        lectureFetchRequest.predicate = NSPredicate(format: "\(Lecture.CodingKeys.stp_lv_nr.rawValue) == %@", lv_nummer)
        let lecture = try context.fetch(lectureFetchRequest).first

        self.init(entity: Grade.entity(), insertInto: context)
        self.datum = datum
        self.exam_typ_name = exam_typ_name
        self.lv_nummer = lv_nummer
        self.lv_semester = lv_semester
        self.lv_titel = lv_titel
        self.modus = modus
        self.pruefer_nachname = pruefer_nachname
        self.st_studium_nr = st_studium_nr
        self.studienbezeichnung = studienbezeichnung
        self.studienidentifikator = studienidentifikator
        self.uninotenamekurz = uninotenamekurz
        self.lecture = lecture
    }
}
