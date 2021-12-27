//
//  LectureDetails.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 25.12.21.
//

import Foundation

// As XMLDecoding is complete BS
typealias LectureDetails = LectureDetailsComponents.Row

enum LectureDetailsComponents {
    struct RowSet: Decodable {
        public var row: [Row]
    }

    struct Row: Decodable, Identifiable {
        let id: UInt64
        let lvNumber: UInt64
        let title: String
        let duration: String
        let stp_sp_sst: String
        let eventType: String
        let eventTypeTag: String
        let semester: String
        let semesterType: String
        let semesterID: String
        let semesterYear: String
        let organisationNumber: UInt64
        let organisation: String
        let organisationTag: String
        let speaker: String
        let courseContents: String?
        let requirements: String?
        let courseObjective: String?
        let teachingMethod: String?
        let anmeld_lv: String?
        let firstScheduledDate: String?
        let examinationMode: String?
        let studienbehelfe: String?
        let note: String?
        let curriculumURL: URL?
        let scheduledDatesURL: URL?
        let examDateURL: URL?

        /*
         <stp_sp_nr>220007563</stp_sp_nr>
         <stp_lv_nr>20007563</stp_lv_nr>
         <stp_sp_titel>Analysis für Informatik</stp_sp_titel>
         <dauer_info>4</dauer_info>
         <stp_sp_sst>4</stp_sp_sst>
         <stp_lv_art_name>Vorlesung</stp_lv_art_name>
         <stp_lv_art_kurz>VO</stp_lv_art_kurz>
         <sj_name>2009/10</sj_name>
         <semester>W</semester>
         <semester_name>Wintersemester 2009/10</semester_name>
         <semester_id>09W</semester_id>
         <org_nr_betreut>14208</org_nr_betreut>
         <org_name_betreut>Zentrum Mathematik</org_name_betreut>
         <org_kennung_betreut>TUMAZMA</org_kennung_betreut>
         <vortragende_mitwirkende>Rentrop P</vortragende_mitwirkende>
         <lehrinhalt isnull="true"></lehrinhalt>
         <voraussetzung_lv isnull="true"></voraussetzung_lv>
         <lehrziel isnull="true"></lehrziel>
         <lehrmethode isnull="true"></lehrmethode>
         <anmeld_lv isnull="true"></anmeld_lv>
         <ersttermin>Di, 20.10.2009, 08:30-10:00 2502, Physik Hörsaal 2</ersttermin>
         <pruefmodus isnull="true"></pruefmodus>
         <studienbehelfe isnull="true"></studienbehelfe>
         <anmerkung isnull="true"></anmerkung>
         <stellung_im_stp_url>http://campus.tum.de/tumonline/wbLv.wbShowStellungInStp?pStpSpNr=220007563</stellung_im_stp_url>
         <termine_url>http://campus.tum.de/tumonline/te_ortzeit.liste?corg=14208&amp;clvnr=220007563</termine_url>
         <pruef_termine_url>http://campus.tum.de/tumonline/DPV.lv_termine?cstp_sp_nr=220007563&amp;cheader=J</pruef_termine_url>
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
            case courseContents = "lehrinhalt"
            case requirements = "voraussetzung_lv"
            case courseObjective = "lehrziel"
            case teachingMethod = "lehrmethode"
            case anmeld_lv
            case firstScheduledDate = "ersttermin"
            case examinationMode = "pruefmodus"
            case studienbehelfe
            case note = "anmerkung"
            case curriculumURL = "stellung_im_stp_url"
            case scheduledDatesURL = "termine_url"
            case examDateURL = "pruef_termine_url"
        }
    }
}

extension LectureDetails {
    static let dummyData: LectureDetails = .init(
        id: 1234,
        lvNumber: 1234,
        title: "Analysis für Informatik",
        duration: "4",
        stp_sp_sst: "1234",
        eventType: "Vorlesung",
        eventTypeTag: "VO",
        semester: "2009/10",
        semesterType: "W",
        semesterID: "09W",
        semesterYear: "2009",
        organisationNumber: 1231,
        organisation: "bla",
        organisationTag: "bla",
        speaker: "Rolles",
        courseContents: "Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis Analysis abc",
        requirements: nil,
        courseObjective: "Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte Integralte abc",
        teachingMethod: nil,
        anmeld_lv: nil,
        firstScheduledDate: "Di, 20.10.2009, 08:30-10:00 2502, Physik Hörsaal 2",
        examinationMode: nil,
        studienbehelfe: nil,
        note: nil,
        curriculumURL: URL(string: "http://campus.tum.de/tumonline/wbLv.wbShowStellungInStp?pStpSpNr=220007563"),
        scheduledDatesURL: URL(string: "http://campus.tum.de/tumonline/te_ortzeit.liste?corg=14208&amp;clvnr=220007563"),
        examDateURL: URL(string: "http://campus.tum.de/tumonline/DPV.lv_termine?cstp_sp_nr=220007563&amp;cheader=J")
    )
}

