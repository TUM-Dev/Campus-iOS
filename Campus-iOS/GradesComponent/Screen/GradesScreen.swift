//
//  GradesScreen.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI
import SwiftUICharts

struct GradesScreen: View {
    @StateObject private var vm: GradesViewModel
    private let model: Model
    @State private var data = AppUsageData()

    init(model: Model) {
        self._vm = StateObject(wrappedValue:
            GradesViewModel(
                model: model,
                service: GradesService()
            )
        )
        self.model = model
    }
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(_):
                VStack {
                    GradesView(
                        vm: self.vm
                    )
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
            data.visitView(view: .grades)
            await vm.getGrades()
        }
        .onDisappear {
            data.exitView(closingApp: false)
        }
        .onChange(of: model.showProfile) { showProfile in
            if showProfile {
                data.exitView(closingApp: false)
            } else {
                data.visitView(view: .grades)
            }
        }
        // As LoginView is just a sheet displayed in front of the GradeScreen
        // Listen to changes on the token, then fetch the grades
        .onChange(of: self.vm.token ?? "") { _ in
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
                    if let campusOnlineError = error as? CampusOnlineAPI.Error {
                        Text(campusOnlineError.errorDescription ?? "CampusOnline Error")
                    } else {
                        Text(error.localizedDescription)
                    }
                }
            }
    }
}

struct GradesScreen_Previews: PreviewProvider {
    static var previews: some View {
        GradesScreen(model: MockModel())
    }
}
