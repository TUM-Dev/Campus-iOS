//
//  Grade+PreviewData.swift
//  Campus-iOS
//
//  Created by David Lin on 05.05.23.
//

import Foundation

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
    
    static var previewData: [Grade] = dummyData21W + dummyData21S + dummyData20W
    
    static let dummyData: [Grade] = [
        Grade(date: .now, lvNumber: "IN4741", semester: "17W", title: "Seminar Teaching iOS", examiner: "Brügge", grade: "1,0", examType: "FA", modus: "Schriftlich", studyID: "1630 17 030", studyDesignation: "Informatik", studyNumber: 947170),
        Grade(date: .now, lvNumber: "IN4741", semester: "17W", title: "Seminar Teaching iOS", examiner: "Brügge", grade: "1,0", examType: "FA", modus: "Schriftlich", studyID: "1630 17 030", studyDesignation: "Informatik", studyNumber: 947170),
        Grade(date: .now, lvNumber: "IN4741", semester: "17W", title: "Seminar Teaching iOS", examiner: "Brügge", grade: "1,0", examType: "FA", modus: "Schriftlich", studyID: "1630 17 030", studyDesignation: "Informatik", studyNumber: 947170)
    ]
} 
