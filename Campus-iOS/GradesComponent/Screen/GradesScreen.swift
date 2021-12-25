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
            case .success(_):
                ScrollView {
                    VStack {
                        BarChartView(barChartData: vm.barChartData)
                         
                        GradesView(gradesBySemester: vm.sortedGradesBySemester)
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
        
                Button("Cancel", role: .cancel) { }
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
