//
//  APIConstants.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation

// As XMLDecoding is complete BS
typealias Grade = GradeComponents.Row

enum GradeComponents {
    struct RowSet: Decodable {
        public var row: [Row]
    }

    struct Row: Decodable, Identifiable {
        // Create own identifier as there isn't one
        public var id: String {
            date.formatted() + "-" + lvNumber
        }
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
        public var studyNumber: UInt64
        
        var modusShort: String {
            switch self.modus {
            case "Schriftlich": return "Written".localized //"Schriftlich"
            case "Beurteilt/immanenter Prüfungscharakter": return "Graded".localized //"Beurteilt"
            case "Schriftlich und Mündlich": return "Written/Oral".localized //"Schriftlich/Mündlich"
            case "Mündlich": return "Oral".localized //"Mündlich"
            default: return "Unknown".localized //"Unbekannt"
            }
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
    }
}

extension Grade {
    static let dummyData21W: [Grade] = [
        Grade(date: .now, lvNumber: "IN0008", semester: "21W", title: "Grundlagen: Datenbanken", examiner: "Kemper", grade: "1,3", examType: "FA", modus: "Schriftlich", studyID: "1630 17 030", studyDesignation: "Informatik", studyNumber: 947170)
    ]
    
    static let dummyData21S: [Grade] = [
        Grade(date: .now, lvNumber: "IN0010E", semester: "21S", title: "Grundlagen: Rechnernetze und verteilte Systeme", examiner: "Carle", grade: "2,7", examType: "FA", modus: "Schriftlich", studyID: "1630 17 030", studyDesignation: "Informatik", studyNumber: 947170),
        Grade(date: .now, lvNumber: "IN0006", semester: "21S", title: "Einführung in die Softwaretechnik", examiner: "Brügge", grade: "2,7", examType: "FA", modus: "Schriftlich", studyID: "1630 17 030", studyDesignation: "Informatik", studyNumber: 947170)
    ]
    
    static let dummyData20W: [Grade] = [
        Grade(date: .now, lvNumber: "IN0001E", semester: "20W", title: "Einführung in die Informatik 1", examiner: "Seidl", grade: "2,3", examType: "FA", modus: "Schriftlich", studyID: "1630 17 030", studyDesignation: "Informatik", studyNumber: 947170),
        Grade(date: .now, lvNumber: "IN0002", semester: "20W", title: "Praktikum Grundlagen der Programmierung", examiner: "Seidl", grade: "1,7", examType: "FA", modus: "Schriftlich", studyID: "1630 17 030", studyDesignation: "Informatik", studyNumber: 947170)
    ]
    
    static var dummyDataAll: [Grade] = dummyData21W + dummyData21S + dummyData20W
    
    static let dummyData: [Grade] = [
        Grade(date: .now, lvNumber: "IN4741", semester: "17W", title: "Seminar Teaching iOS", examiner: "Brügge", grade: "1,0", examType: "FA", modus: "Schriftlich", studyID: "1630 17 030", studyDesignation: "Informatik", studyNumber: 947170),
        Grade(date: .now, lvNumber: "IN4741", semester: "17W", title: "Seminar Teaching iOS", examiner: "Brügge", grade: "1,0", examType: "FA", modus: "Schriftlich", studyID: "1630 17 030", studyDesignation: "Informatik", studyNumber: 947170),
        Grade(date: .now, lvNumber: "IN4741", semester: "17W", title: "Seminar Teaching iOS", examiner: "Brügge", grade: "1,0", examType: "FA", modus: "Schriftlich", studyID: "1630 17 030", studyDesignation: "Informatik", studyNumber: 947170)
    ]
}

