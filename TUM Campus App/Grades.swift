//
//  File.swift
//  Campus
//
//  Created by Tim Gymnich on 20.10.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Foundation
//
//  Grade.swift
//  TUM Campus App
//
//  Created by Florian Gareis on 04.02.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Foundation


class Grades: DataElement {
    
    let name: String
    let grades: [Grade]
    var totalECTS: Int {
        return grades.reduce(0, {$0 + $1.ects})
    }
    var averge: Double {
        return grades.reduce(0, {$0 + $1.grade}) / Double(grades.count)
    }
    
    init(name: String, grades: [Grade]) {
        self.name = name
        self.grades = grades
    }
    
    func ectsForSemester(semester: String) -> Int {
        var ects = 0
        for grade in grades where grade.semester == semester {
            ects += grade.ects
        }
        return ects
    }
    
    func getCellIdentifier() -> String {
        return "grades"
    }
    
    var text: String {
        return name
    }
}
