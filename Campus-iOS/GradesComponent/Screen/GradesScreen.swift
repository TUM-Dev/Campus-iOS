//
//  GradesScreen.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI
import SwiftUICharts

@available(iOS 16.0, *)
struct GradesScreen: View {
    @StateObject var vm: GradesViewModel
    @Binding var refresh: Bool
    
    init(model: Model, refresh: Binding<Bool>) {
        self._vm = StateObject(wrappedValue:
                                GradesViewModel(
                                    model: model,
                                    gradesService: GradesService(),
                                    averageGradesService: AverageGradesService()
                                )
        )
        
        self._refresh = refresh
    }
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(_):
                if vm.grades.count <= 0 {
                    FailedView(
                            errorDescription: "No grades yet!",
                            retryClosure: vm.reloadGradesAndAverageGrades
                        )
                } else {
                    VStack {
                        GradesView(
                            vm: self.vm
                        )
                        .padding(.top, 30)
                        .refreshable {
                            await vm.reloadGradesAndAverageGrades(forcedRefresh: true)
                        }
                    }
                }
            case .loading, .na:
                LoadingView(text: "Fetching Grades")
            case .failed(let error):
                FailedView(
                    errorDescription: error.localizedDescription,
                    retryClosure: vm.reloadGradesAndAverageGrades
                )
            }
        }
        .task {
            await vm.reloadGradesAndAverageGrades()
        }
        // Refresh whenever user authentication status changes
        .onChange(of: self.refresh) { _ in
            Task {
                await vm.reloadGradesAndAverageGrades()
            }
        }
        // As LoginView is just a sheet displayed in front of the GradeScreen
        // Listen to changes on the token, then fetch the grades
        .onChange(of: self.vm.model.token ?? "") { _ in
            Task {
                await vm.reloadGradesAndAverageGrades()
            }
        }
        .alert(
            "Error while fetching Grades",
            isPresented: $vm.hasError,
            presenting: vm.state) { detail in
                Button("Retry") {
                    Task {
                        await vm.reloadGradesAndAverageGrades()
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

@available(iOS 16.0, *)
struct GradesScreen_Previews: PreviewProvider {
    static var previews: some View {
        GradesScreen(model: MockModel(), refresh: .constant(false))
    }
}
