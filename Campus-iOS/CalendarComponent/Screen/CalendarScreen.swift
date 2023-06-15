//
//  CalendarScreen.swift
//  Campus-iOS
//
//  Created by David Lin on 20.01.23.
//

import SwiftUI

struct CalendarScreen: View {
    @StateObject var vm: CalendarViewModel
    @Binding var refresh: Bool
    
    init(model: Model, refresh: Binding<Bool>) {
        self._vm = StateObject(wrappedValue:
            CalendarViewModel(
                model: model,
                service: CalendarService()
            )
        )
        self._refresh = refresh
    }
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let events):
                VStack {
                    CalendarContentView(
                        model: self.vm.model, events: events
                    )
                    .padding(.bottom)
                    .refreshable {
                        await vm.getCalendar(forcedRefresh: true)
                    }
                }
            case .loading, .na:
                LoadingView(text: "Fetching Calendar")
            case .failed(let error):
                FailedView(
                    errorDescription: error.localizedDescription,
                    retryClosure: vm.getCalendar
                )
            }
        }
        .task {
            await vm.getCalendar()
        }
        // Refresh whenever user authentication status changes
        .onChange(of: self.refresh) { _ in
            Task {
                await vm.getCalendar()
            }
        }
        // As LoginView is just a sheet displayed in front of the GradeScreen
        // Listen to changes on the token, then fetch the grades
        .onChange(of: self.vm.model.token ?? "") { _ in
            Task {
                await vm.getCalendar()
            }
        }
        .alert(
            "Error while fetching Grades",
            isPresented: $vm.hasError,
            presenting: vm.state) { detail in
                Button("Retry") {
                    Task {
                        await vm.getCalendar(forcedRefresh: true)
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
