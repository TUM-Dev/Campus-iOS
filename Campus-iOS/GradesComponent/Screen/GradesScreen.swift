//
//  GradesScreen.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI
import SwiftUICharts

struct GradesScreen: View {
    @StateObject var vm: GradesViewModel
    @Binding var refresh: Bool

    init(model: Model, refresh: Binding<Bool>) {
        self._vm = StateObject(wrappedValue:
            GradesViewModel(
                model: model,
                service: GradesService()
            )
        )
        self._refresh = refresh
    }
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let data):
                VStack {
                    GradesView(grades: data, gradesSemesterDegrees: GradesViewModel.gradesByDegreeAndSemester(data: data), barChartData: GradesViewModel.barChartData(data: data), studyProgramm: GradesViewModel.getStudyProgram(for: data.first))
                        .refreshable {
                        await vm.getGrades(forcedRefresh: true)
                    }
                }
            case .loading, .na:
                LoadingView(text: "Fetching Grades")
            case .failed(let error):
                FailedView(
                    errorDescription: error.localizedDescription,
                    retryClosure: vm.getGrades
                )
            }
        }
        .task {
            await vm.getGrades()
        }
        // Refresh whenever user authentication status changes
        .onChange(of: self.refresh) { _ in
            Task {
                await vm.getGrades()
            }
        }
        // As LoginView is just a sheet displayed in front of the GradeScreen
        // Listen to changes on the token, then fetch the grades
        .onChange(of: self.vm.model.token ?? "") { _ in
            Task {
                await vm.getGrades()
            }
        }
        .alert(
            "Error while fetching Grades",
            isPresented: $vm.hasError,
            presenting: vm.state) { detail in
                Button("Retry") {
                    Task {
                        await vm.getGrades(forcedRefresh: true)
                    }
                }
        
                Button("Cancel", role: .cancel) { }
            } message: { detail in
                if case let .failed(error) = detail {
                    if let apiError = error as? TUMOnlineAPIError {
                        Text(apiError.errorDescription ?? "TUMOnlineAPI Error")
                    } else {
                        Text(error.localizedDescription)
                    }
                }
            }
    }
}

struct GradesScreen_Previews: PreviewProvider {
    static var previews: some View {
        GradesScreen(model: MockModel(), refresh: .constant(false))
    }
}
