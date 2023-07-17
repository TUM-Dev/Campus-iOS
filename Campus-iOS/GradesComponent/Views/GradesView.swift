//
//  GradesView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 24.12.21.
//

import SwiftUI
import SwiftUICharts

struct GradesView: View {
    
    @State private var data = AppUsageData()
    
    let grades: [Grade]
    let gradesSemesterDegrees: GradesSemesterDegrees
    let barChartData: [BarChartData]
    let studyProgramm: String
    
    var body: some View {
        let gradesWithAverage = self.vm.gradesByDegreeAndSemesterWithAverageGrade
        
        return List {
            ForEach(gradesWithAverage.indices, id: \.self) { index in
                GradesStudyProgramView(semesterGrades: gradesWithAverage[index], studyProgram: self.vm.getStudyProgram(studyID: gradesWithAverage[index].degree), barChartData: vm.barChartData[index])
            }
        }
        .task {
            data.visitView(view: .grades)
        }
        .onDisappear {
            data.didExitView()
        }
    }
}
