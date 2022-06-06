//
//  APIConstants.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation

// As XMLDecoding is complete BS
typealias Lecture = LectureComponents.Row

enum LectureComponents {
    struct RowSet: Decodable {
        public var row: [Row]
    }

    struct Row: Decodable, Identifiable, Equatable {
        public var id: UInt64
        public var lvNumber: UInt64
        public var title: String
        public var duration: String
        public var stp_sp_sst: String
        public var eventTypeDefault: String
        public var eventTypeTag: String
        public var semesterYear: String
        public var semesterType: String
        public var semester: String
        public var semesterID: String
        public var organisationNumber: UInt64
        public var organisation: String
        public var organisationTag: String
        public var speaker: String
        
        public var eventType: String {
            switch self.eventTypeDefault {
            case "Vorlesung":
                return "Lecture".localized
            case "Tutorium", "Übung":
                return "Exercise".localized
            case "Praktikum":
                return "Practical course".localized
            case "Seminar":
                return "Seminar".localized
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
        }
    }
}

extension Lecture {
    static let dummyData: [Lecture] = [
        Lecture(id: 950396293, lvNumber: 90049615, title: "Practical course - Program optimization with LLVM (IN0012, IN2106, IN4236)", duration: "6", stp_sp_sst: "6", eventTypeDefault: "Praktikum", eventTypeTag: "PR", semesterYear: "2018/19", semesterType: "W", semester: "Wintersemester 2018/19", semesterID: "18W", organisationNumber: 15427, organisation: "Informatik 2 - Lehrstuhl für Sprachen und Beschreibungsstrukturen in der Informatik (Prof. Seidl)", organisationTag: "TUINI02", speaker: "Seidl H [L], Petter M"),
        Lecture(id: 950396293, lvNumber: 90049615, title: "Practical course - Program optimization with LLVM (IN0012, IN2106, IN4236)", duration: "6", stp_sp_sst: "6", eventTypeDefault: "Praktikum", eventTypeTag: "PR", semesterYear: "2018/19", semesterType: "W", semester: "Wintersemester 2018/19", semesterID: "18W", organisationNumber: 15427, organisation: "Informatik 2 - Lehrstuhl für Sprachen und Beschreibungsstrukturen in der Informatik (Prof. Seidl)", organisationTag: "TUINI02", speaker: "Seidl H [L], Petter M"),
        Lecture(id: 950396293, lvNumber: 90049615, title: "Practical course - Program optimization with LLVM (IN0012, IN2106, IN4236)", duration: "6", stp_sp_sst: "6", eventTypeDefault: "Praktikum", eventTypeTag: "PR", semesterYear: "2018/19", semesterType: "W", semester: "Wintersemester 2018/19", semesterID: "18W", organisationNumber: 15427, organisation: "Informatik 2 - Lehrstuhl für Sprachen und Beschreibungsstrukturen in der Informatik (Prof. Seidl)", organisationTag: "TUINI02", speaker: "Seidl H [L], Petter M")
    ]
}
