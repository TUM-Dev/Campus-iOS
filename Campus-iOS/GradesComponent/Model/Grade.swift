//
//  APIConstants.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation

// As XMLDecoding is complete BS
typealias Grade = Row

struct RowSet: Decodable {
    public var row: [Row]
}

struct Row: Decodable {
    public var date: Date
    public var lvNumber: String
    public var semester: String
    public var title: String
    public var examiner: String
    public var grade: String
    public var examType: String
    public var modus: String
    public var studyID: String
    public var studyDesignation: String
    public var studyNumber: Int
    
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
}

extension Grade {
    static let dummyData: [Grade] = [
        Grade(date: Date(timeIntervalSinceNow: .zero), lvNumber: "IN4741", semester: "17W", title: "Seminar Teaching iOS", examiner: "Brügge", grade: "1,0", examType: "FA", modus: "Beurteilt/immanenter Prüfungscharakter", studyID: "1630 17 030", studyDesignation: "Informatik", studyNumber: 947170),
        Grade(date: Date(timeIntervalSinceNow: .zero), lvNumber: "IN4741", semester: "17W", title: "Seminar Teaching iOS", examiner: "Brügge", grade: "1,0", examType: "FA", modus: "Beurteilt/immanenter Prüfungscharakter", studyID: "1630 17 030", studyDesignation: "Informatik", studyNumber: 947170),
        Grade(date: Date(timeIntervalSinceNow: .zero), lvNumber: "IN4741", semester: "17W", title: "Seminar Teaching iOS", examiner: "Brügge", grade: "1,0", examType: "FA", modus: "Beurteilt/immanenter Prüfungscharakter", studyID: "1630 17 030", studyDesignation: "Informatik", studyNumber: 947170)
    ]
}
