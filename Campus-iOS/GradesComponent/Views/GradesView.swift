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
        List {
            ForEach(gradesSemesterDegrees.indices, id: \.self) { index in
                VStack {
                    Text(studyProgramm)
                    .font(
                        .system(
                            size: 20,
                            weight: .bold,
                            design: .default
                        )
                    )
                    .frame(alignment: .center)

                    BarChartView(barChartData: barChartData[index])
                }
                
                ForEach(gradesSemesterDegrees[index].1, id: \.0) { gradesBySemester in
                    Section(header: Text(gradesBySemester.0)
                        .font(.headline.bold())
                        .foregroundColor(Color("tumBlue"))
                    ) {
                        ForEach(gradesBySemester.1) { item in
                            VStack {
                                GradeView(grade: item)

                                if item.id != gradesBySemester.1[gradesBySemester.1.count - 1].id {
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
                .listRowSeparator(.hidden)
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

struct GradesView_Previews: PreviewProvider {
    static var previews: some View {
        GradesView(grades: Grade.previewData, gradesSemesterDegrees: GradesViewModel.previewGradesSemesterDegree, barChartData: GradesViewModel.previewBarChartData, studyProgramm: GradesViewModel.getStudyProgram(for: Grade.previewData.first))
    }
}
