//
//  GradesView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 24.12.21.
//

import SwiftUI
import SwiftUICharts

struct GradesView: View {
    var gradesBySemester: [(String, [Grade])]
    var barChartData: BarChartData
    
    var body: some View {
        List {
            BarChartView(barChartData: barChartData)
            
            ForEach(gradesBySemester, id: \.0) { gradesBySemester in
                Section(
                    header:
                        GroupBoxLabelView(
                            iconName: "graduationcap",
                            text: gradesBySemester.0
                        )
                ) {
                    ForEach(gradesBySemester.1) { item in
                        GradeView(grade: item)
                    }
                }
            }
        }
    }
}

struct GradesView_Previews: PreviewProvider {
    static var previews: some View {
        GradesView(
            gradesBySemester: [],
            barChartData:
                .init(
                    dataSets: .init(dataPoints: [])
                )
        )
    }
}
