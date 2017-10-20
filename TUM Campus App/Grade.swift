//
//  Grade.swift
//  TUM Campus App
//
//  Created by Florian Gareis on 04.02.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Foundation

class Grade: DataElement {
    
    let name: String
    let result: String
    let grade: Double
    let date: Date
    let semester: String
    let ects: Int
    let examiner: String
    let mode: String
    
    init(name: String, result: String, grade: Double, date: Date, semester: String, ects: Int, examiner: String, mode: String) {
        self.name = name
        self.result = result
        self.grade = grade
        self.date = date
        self.semester = semester
        self.ects = ects
        self.examiner = examiner
        self.mode = mode
    }
    
    func getCellIdentifier() -> String {
        return "grade"
    }
    
    var text: String {
        return name
    }
}
