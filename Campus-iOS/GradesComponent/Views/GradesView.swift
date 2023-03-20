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
    @State private var data = AppUsageData()
    
    var body: some View {
        List {
            ForEach(self.vm.gradesByDegreeAndSemester.indices, id: \.self) { index in
                VStack {
                    Text(
                        self.vm.getStudyProgram(studyID: self.vm.gradesByDegreeAndSemester[index].0)
                    )
                    .font(
                        .system(
                            size: 20,
                            weight: .bold,
                            design: .default
                        )
                    )
                    .frame(alignment: .center)
                    
                    BarChartView(barChartData: self.vm.barChartData[index])
                }
                
                ForEach(self.vm.gradesByDegreeAndSemester[index].1, id: \.0) { gradesBySemester in
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
            .listRowBackground(Color.secondaryBackground)
        }
        .background(Color.primaryBackground)
        .scrollContentBackground(.hidden)
        .task {
            data.visitView(view: .grades)
        }
        .onDisappear {
            data.didExitView()
        }
        
    }
}

@available(iOS 16.0, *)
struct GradesView_Previews: PreviewProvider {
    static var previews: some View {
        GradesView(vm:
                    MockGradesViewModel(
                        model: MockModel(),
                        service: GradesService()
                    )
        )
    }
}
