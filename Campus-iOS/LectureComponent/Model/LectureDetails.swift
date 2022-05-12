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
        let eventTypeDefault: String
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
        
        var speakerArray: [String] {
            self.speaker.split(separator: ",").map({ $0.trimmingCharacters(in: .whitespaces) })
        }
        
        public var eventType: String {
            switch self.eventTypeDefault {
            case "Vorlesung":
                return "Lecture".localized
            case "Tutorium":
                return "Exercise".localized
            case "Praktikum":
                return "Practice".localized
            case "Vorlesung mit integrierten Übungen":
                return "Lecture with integrated Exercises".localized
            default:
                return ""
            }
        }

        enum CodingKeys: String, CodingKey {
            case id = "stp_sp_nr"
            case lvNumber = "stp_lv_nr"
            case title = "stp_sp_titel"
            case duration = "dauer_info"
            case stp_sp_sst = "stp_sp_sst"
            case eventTypeDefault = "stp_lv_art_name"
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
        eventTypeDefault: "Vorlesung",
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

