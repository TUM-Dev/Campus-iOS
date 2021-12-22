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
            if vm.grades.isEmpty {
                LoadingView(text: "Fetching Grades")
            } else {
                VStack {
                    BarChart(chartData: vm.barChartData)
                        .xAxisGrid(chartData: vm.barChartData)
                        //.yAxisGrid(chartData: vm.barChartData)
                        .xAxisLabels(chartData: vm.barChartData)
                        .yAxisLabels(chartData: vm.barChartData)
                        .legends(chartData: vm.barChartData)
                        .frame(height: UIScreen.main.bounds.size.height/5, alignment: .center)
                        .padding(.horizontal)                        
                    
                    List {
                        ForEach(vm.grades) { item in
                            GradeView(grade: item)
                        }
                    }
                     
                }
            }
        }
        .task {
            await vm.getGrades(token: environmentValues.user.token)
        }
    }
}

struct GradesScreen_Previews: PreviewProvider {
    static var previews: some View {
        GradesScreen()
    }
}
