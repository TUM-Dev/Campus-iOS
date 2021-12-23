//
//  GradesScreen.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI
import SwiftUICharts

struct GradesScreen: View {
    @EnvironmentObject private var environmentValues: CustomEnvironmentValues
    
    @StateObject private var vm = GradesViewModel(
        serivce: GradesService()
    )
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let _):
                ScrollView {
                    VStack {
                        BarChart(chartData: vm.barChartData)
                            .xAxisGrid(chartData: vm.barChartData)
                            //.yAxisGrid(chartData: vm.barChartData)
                            .xAxisLabels(chartData: vm.barChartData)
                            .yAxisLabels(chartData: vm.barChartData)
                            .legends(chartData: vm.barChartData)
                            .frame(height: UIScreen.main.bounds.size.height/4, alignment: .center)
                            .padding([.horizontal, .top])
                         
                        ForEach(vm.sortedGradesBySemester, id: \.0) { gradesBySemester in
                            GroupBox(
                                label: HStack {
                                    Image(systemName: "graduationcap")
                                        .imageScale(.medium)   
                                    Text(gradesBySemester.0)
                                        .font(.system(size: 18))
                                }.foregroundColor(.blue)
                            ) {
                                ForEach(gradesBySemester.1) { item in
                                    GradeView(grade: item)
                                    
                                    if item.id != gradesBySemester.1.last?.id {
                                        Divider()
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            case .loading, .na:
                LoadingView(text: "Fetching Grades")
            case .failed(let error):
                FailedView(errorDescription: error.localizedDescription)
            }
        }
        .task {
            await vm.getGrades(token: environmentValues.user.token)
        }
        .alert(
            "Error while fetching Grades",
            isPresented: $vm.hasError,
            presenting: vm.state) { detail in
                Button("Retry") {
                    Task {
                        await vm.getGrades(token: environmentValues.user.token)
                    }
                }
        
                Button("Cancle", role: .cancel) { }
            } message: { detail in
                if case let .failed(error) = detail {
                    Text(error.localizedDescription)
                }
            }
    }
}

struct GradesScreen_Previews: PreviewProvider {
    static var previews: some View {
        GradesScreen()
    }
}
