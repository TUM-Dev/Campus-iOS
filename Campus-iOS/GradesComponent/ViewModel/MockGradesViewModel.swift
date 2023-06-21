//
//  MockGradesViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 03.05.22.
//

import Foundation
import SwiftUICharts

class MockGradesViewModel: GradesViewModel {
    
    let dummyGradesByDegreeAndSemester: [(String, [(String, [Grade])])] = [
        ("1630 17 030", [("Wintersemester 2021/22", Grade.dummyData21W)]),
        ("1630 17 030", [("Sommersemester 2021", Grade.dummyData21S)]),
        ("1630 17 030", [("Wintersemester 2020/21", Grade.dummyData20W)])
    ]
    
    override init(model: Model, gradesService: GradesService, averageGradesService: AverageGradesService) {
        super.init(model: model, gradesService: gradesService, averageGradesService: AverageGradesService())
        
        self.gradesState = .success(data: Grade.dummyDataAll)
        self.averageGradesState = .success(data: AverageGrade.dummyData)
    }
}

