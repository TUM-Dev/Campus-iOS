//
//  GradesSemesterView.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 23.05.23.
//

import SwiftUI
import SwiftUICharts

struct GradesStudyProgramView: View {
    let semesterGrades: GradesViewModel.GradesByDegreeAndSemesterWithAverageGrade
    let studyProgram: String
    let barChartData: BarChartData
    
    var body: some View {
        VStack {
            Text(
                studyProgram
            )
            .font(
                .system(
                    size: 20,
                    weight: .bold,
                    design: .default
                )
            )
            .frame(alignment: .center)
            
            BarChartView(barChartData: barChartData)
            
            if let avgRounded = semesterGrades.averageGrade?.averageGradeRounded {
                Divider()
                
                HStack {
                    Text("Average Grade:")
                    Spacer()
                    Text("\(avgRounded)")
                        .bold()
                }
            }
        }
        
        ForEach(Array(semesterGrades.semester.keys).sorted(by: >), id: \.self) { semesterKey in
            GradesSemesterView(semesterName: GradesViewModel.toFullSemesterName(semesterKey), grades: semesterGrades.semester[semesterKey] ?? [])
        }
        .listRowSeparator(.hidden)
    }
}

