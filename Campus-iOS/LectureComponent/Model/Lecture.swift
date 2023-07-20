//
//  LectureComponents.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation

struct Lecture: Decodable, Identifiable, Equatable, Searchable {
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
    
    var comparisonTokens: [ComparisonToken] {
        return [
            ComparisonToken(value: title),
            ComparisonToken(value: semesterID, type: .raw),
            ComparisonToken(value: organisation),
            ComparisonToken(value: speaker),
            ComparisonToken(value: semester)
        ]
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


extension Lecture {
    static let dummyData: [Lecture] = [
        Lecture(id: 950396293, lvNumber: 90049615, title: "Practical course - Program optimization with LLVM (IN0012, IN2106, IN4236)", duration: "6", stp_sp_sst: "6", eventTypeDefault: "Praktikum", eventTypeTag: "PR", semesterYear: "2018/19", semesterType: "W", semester: "Wintersemester 2018/19", semesterID: "18W", organisationNumber: 15427, organisation: "Informatik 2 - Lehrstuhl für Sprachen und Beschreibungsstrukturen in der Informatik (Prof. Seidl)", organisationTag: "TUINI02", speaker: "Seidl H [L], Petter M"),
        Lecture(id: 950630619, lvNumber: 40984991, title: "Grundlagen: Betriebssysteme und Systemsoftware (IN0009)", duration: "3", stp_sp_sst: "3", eventTypeDefault: "Vorlesung", eventTypeTag: "VO", semesterYear: "2022/23", semesterType: "W", semester: "Wintersemester 2022/23", semesterID: "22W", organisationNumber: 47337, organisation: "Informatik 11 - Lehrstuhl für Connected Mobility (Prof. Ott)", organisationTag: "TUINI24", speaker: "Ott J [L], Ott J, Uhl M"),
        Lecture(id: 950629892, lvNumber: 20007563, title: "Analysis für Informatik [MA0902]", duration: "4", stp_sp_sst: "4", eventTypeDefault: "Vorlesung", eventTypeTag: "VO", semesterYear: "2022/23", semesterType: "W", semester: "Wintersemester 2022/23", semesterID: "22W", organisationNumber: 53597, organisation: "Department of Mathematics", organisationTag: "TUS1DP1", speaker: "Rolles S")
    ]
}

/*
<row>
<stp_sp_nr>950630619</stp_sp_nr>
<stp_lv_nr>40984991</stp_lv_nr>
<stp_sp_titel>Grundlagen: Betriebssysteme und Systemsoftware (IN0009)</stp_sp_titel>
<dauer_info>3</dauer_info>
<stp_sp_sst>3</stp_sp_sst>
<stp_lv_art_name>Vorlesung</stp_lv_art_name>
<stp_lv_art_kurz>VO</stp_lv_art_kurz>
<sj_name>2022/23</sj_name>
<semester>W</semester>
<semester_name>Wintersemester 2022/23</semester_name>
<semester_id>22W</semester_id>
<org_nr_betreut>47337</org_nr_betreut>
<org_name_betreut>Informatik 11 - Lehrstuhl für Connected Mobility (Prof. Ott)</org_name_betreut>
<org_kennung_betreut>TUINI24</org_kennung_betreut>
<vortragende_mitwirkende>Ott J [L], Ott J, Uhl M</vortragende_mitwirkende>
</row>
<row>
<stp_sp_nr>950629892</stp_sp_nr>
<stp_lv_nr>20007563</stp_lv_nr>
<stp_sp_titel>Analysis für Informatik [MA0902]</stp_sp_titel>
<dauer_info>4</dauer_info>
<stp_sp_sst>4</stp_sp_sst>
<stp_lv_art_name>Vorlesung</stp_lv_art_name>
<stp_lv_art_kurz>VO</stp_lv_art_kurz>
<sj_name>2022/23</sj_name>
<semester>W</semester>
<semester_name>Wintersemester 2022/23</semester_name>
<semester_id>22W</semester_id>
<org_nr_betreut>53597</org_nr_betreut>
<org_name_betreut>Department of Mathematics</org_name_betreut>
<org_kennung_betreut>TUS1DP1</org_kennung_betreut>
<vortragende_mitwirkende>Rolles S</vortragende_mitwirkende>
</row>
*/
