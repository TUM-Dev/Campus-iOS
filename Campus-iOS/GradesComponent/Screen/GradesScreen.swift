//
//  GradesScreen.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI
import SwiftUICharts
import CoreData

struct GradesScreen: View {
    @StateObject var vm: GradesViewModel
    @Binding var refresh: Bool

    init(context: NSManagedObjectContext, model: Model, refresh: Binding<Bool>) {
        self._vm = StateObject(wrappedValue:
            GradesViewModel(
                context: context,
                model: model,
                service: GradesService()
            )
        )
        self._refresh = refresh
    }
    
    var body: some View {
        Group {
            switch vm.state {
            case .success:
                VStack {
                    GradesView(
                        vm: self.vm
                    )
//                        .refreshable {
//                            await vm.getGrades()
//                        }
                }
            case .loading, .na:
                LoadingView(text: "Fetching Grades")
            case .failed(let error):
                FailedView(
                    errorDescription: error.localizedDescription,
//                    retryClosure: vm.getGrades
                    retryClosure: {_ in }
                )
            }
        }
        .task {
            await vm.getGrades()
        }
        // Refresh whenever user authentication status changes
//            .onChange(of: self.refresh) { _ in
//                Task {
//                    await vm.getGrades()
//                }
//            }
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
                        await vm.getGrades()
                    }
                }
                
                Button("Cancel", role: .cancel) { }
            } message: { detail in
                if case let .failed(error) = detail {
                    if let campusOnlineError = error as? TUMOnlineAPIError {
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
        GradesScreen(context: PersistenceController.shared.container.viewContext, model: MockModel(), refresh: .constant(false))
    }
}
