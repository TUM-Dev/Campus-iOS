//
//  GradesView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 24.12.21.
//

import SwiftUI
import SwiftUICharts

@available(iOS 16.0, *)
struct GradesView: View {
    
    @StateObject var vm: GradesViewModel
    
    var body: some View {
        let gradesWithAverage = self.vm.gradesByDegreeAndSemesterWithAverageGrade
        
        return List {
            ForEach(gradesWithAverage.indices, id: \.self) { index in
                GradesStudyProgramView(semesterGrades: gradesWithAverage[index], studyProgram: self.vm.getStudyProgram(studyID: gradesWithAverage[index].degree), barChartData: vm.barChartData.count > index ? vm.barChartData[index] : BarChartData(dataSets: BarDataSet(dataPoints: [])))
            }
            .listRowBackground(Color.secondaryBackground)
        }
        .background(Color.primaryBackground)
        .scrollContentBackground(.hidden)
    }
}
