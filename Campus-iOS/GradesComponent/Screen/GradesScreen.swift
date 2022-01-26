//
//  GradesScreen.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI
import SwiftUICharts

struct GradesScreen: View {
    @StateObject var model: Model
    //@EnvironmentObject private var model: Model
    
    @StateObject private var vm = GradesViewModel(
        serivce: GradesService()
    )
    
    private var token: String? {
        switch self.model.loginController.credentials {
        case .none, .noTumID:
            return nil
        case .tumID(_, let token):
            return token
        case .tumIDAndKey(_, let token, _):
            return token
        }
    }
    
    var body: some View {
        Group {
            if let token = self.token {
                switch vm.state {
                case .success(_):
                    VStack {
                        GradesView(
                            gradesBySemester: vm.sortedGradesBySemester,
                            barChartData: vm.barChartData
                        )
                        .refreshable {
                            await vm.getGrades(
                                token: token,
                                forcedRefresh: true
                            )
                        }
                    }
                case .loading, .na:
                    LoadingView(text: "Fetching Grades")
                case .failed(let error):
                    FailedView(errorDescription: error.localizedDescription)
                }
            } else {
                FailedView(errorDescription: "Please log in")
            }
        }
        .task {
            guard let token = self.token else {
                return
            }
            await vm.getGrades(token: token)
        }
        // As LoginView is just a sheet displayed in front of the GradeScreen
        // Listen to changes on the token, then fetch the grades
        .onChange(of: self.token ?? "") { _ in
            Task {
                guard let token = self.token else {
                    return
                }
                await vm.getGrades(token: token)
            }
        }
        .alert(
            "Error while fetching Grades",
            isPresented: $vm.hasError,
            presenting: vm.state) { detail in
                Button("Retry") {
                    Task {
                        guard let token = self.token else {
                            return
                        }
                        await vm.getGrades(token: token)
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
        GradesScreen(model: MockModel())
        //GradesScreen()
    }
}
