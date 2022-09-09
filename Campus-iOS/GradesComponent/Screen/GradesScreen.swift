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
            await vm.getGrades()
        }
        // Refresh whenever user authentication status changes
        .onChange(of: self.refresh) { _ in
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
        GradesScreen(vm: GradesViewModel(
            model: MockModel(),
            service: GradesService()
        ), refresh: .constant(false))
    }
}
