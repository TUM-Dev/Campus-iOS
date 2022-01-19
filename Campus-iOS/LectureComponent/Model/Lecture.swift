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

    struct Row: Decodable, Identifiable {
        public var id: UInt64
        public var lvNumber: UInt64
        public var title: String
        public var duration: String
        public var stp_sp_sst: String
        public var eventType: String
        public var eventTypeTag: String
        public var semesterYear: String
        public var semesterType: String
        public var semester: String
        public var semesterID: String
        public var organisationNumber: UInt64
        public var organisation: String
        public var organisationTag: String
        public var speaker: String
        
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
    }
}

extension Lecture {
    static let dummyData: [Lecture] = [
        Lecture(id: 950396293, lvNumber: 90049615, title: "Practical course - Program optimization with LLVM (IN0012, IN2106, IN4236)", duration: "6", stp_sp_sst: "6", eventType: "Praktikum", eventTypeTag: "PR", semesterYear: "2018/19", semesterType: "W", semester: "Wintersemester 2018/19", semesterID: "18W", organisationNumber: 15427, organisation: "Informatik 2 - Lehrstuhl für Sprachen und Beschreibungsstrukturen in der Informatik (Prof. Seidl)", organisationTag: "TUINI02", speaker: "Seidl H [L], Petter M"),
        Lecture(id: 950396293, lvNumber: 90049615, title: "Practical course - Program optimization with LLVM (IN0012, IN2106, IN4236)", duration: "6", stp_sp_sst: "6", eventType: "Praktikum", eventTypeTag: "PR", semesterYear: "2018/19", semesterType: "W", semester: "Wintersemester 2018/19", semesterID: "18W", organisationNumber: 15427, organisation: "Informatik 2 - Lehrstuhl für Sprachen und Beschreibungsstrukturen in der Informatik (Prof. Seidl)", organisationTag: "TUINI02", speaker: "Seidl H [L], Petter M"),
        Lecture(id: 950396293, lvNumber: 90049615, title: "Practical course - Program optimization with LLVM (IN0012, IN2106, IN4236)", duration: "6", stp_sp_sst: "6", eventType: "Praktikum", eventTypeTag: "PR", semesterYear: "2018/19", semesterType: "W", semester: "Wintersemester 2018/19", semesterID: "18W", organisationNumber: 15427, organisation: "Informatik 2 - Lehrstuhl für Sprachen und Beschreibungsstrukturen in der Informatik (Prof. Seidl)", organisationTag: "TUINI02", speaker: "Seidl H [L], Petter M")
    ]
}