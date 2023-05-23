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
                
                
                
                /* ForEach(self.vm.gradesByDegreeAndSemesterWithAverageGrade[index].semester, id: \.key) { semester, grades in
                 Section(header: Text(semester)
                 .font(.headline.bold())
                 .foregroundColor(Color("tumBlue"))
                 ) {
                 ForEach(grades) { item in
                 VStack {
                 GradeView(grade: item)
                 
                 if item.id != grades[grades.count - 1].id {
                 Divider()
                 }
                 }
                 }
                 .listRowInsets(
                 EdgeInsets(
                 top: 4,
                 leading: 18,
                 bottom: 2,
                 trailing: 18
                 )
                 )
                 }
                 }
                 .listRowSeparator(.hidden) */
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
