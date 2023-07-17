//
//  GradesView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 24.12.21.
//

import SwiftUI
import SwiftUICharts

struct GradesView: View {
    
    @StateObject var vm: GradesViewModel
    @State private var data = AppUsageData()
    
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
