//
//  GradesScreen.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI
import SwiftUICharts
import XMLCoder
import CoreData

struct GradesScreen: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var grades: FetchedResults<Grade>
    
    static let decoder: XMLDecoder = {
        let decoder = XMLDecoder()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }()
    
    @StateObject var vm: GradesViewModel
    @Binding var refresh: Bool

    init(model: Model, refresh: Binding<Bool>, context: NSManagedObjectContext) {
        self._vm = StateObject(wrappedValue:
            GradesViewModel(
                model: model,
                service: GradesService(),
                context: context
            )
        )
        self._refresh = refresh
    }
    
    var body: some View {
        VStack {
            Button("Get grades from viewModel") {
                Task {
                    try await vm.fetchGrades()
                }
            }
            Button("Get grades") {
                //                Task {
                //                    await vm.getGrades()
                //                }
                
                Task {
                    // Very Important: Add moc to the CodingUserInfoKey to make an initialization of Grade-Objects possible via the init(from:)-Initializer (i.e. via the Decoder)
                    //                    CampusOnlineAPI.decoder.userInfo[CodingUserInfoKey.managedObjectContext] = moc
                    
                    
                    var data: Data
                    do {
                        data = try await Constants.API.CampusOnline.personalGrades.asRequest(token: vm.token).serializingData().value
                    } catch {
                        print(error)
                        throw NetworkingError.deviceIsOffline
                    }
                    
                    do {
                        Self.decoder.userInfo[CodingUserInfoKey.managedObjectContext] = moc
                        let newGradeSet = try Self.decoder.decode(RowSet<Grade>.self, from: data)
                        
                        let newGrades = newGradeSet.row
                        
                        for grade in newGrades {
                            print(grade.title)
                        }
                        
                        try moc.save()
                        print("Saved")
                        
                        print("Count: \(newGrades.count)")
                    } catch {
                        print(error)
                    }
                }
            }
            
            List {
                ForEach(grades, id: \.self) { grade in
                    HStack{
                        Text(grade.title ?? "NO TITLE")
                        Text(grade.grade ?? "NO GRADE")
                    }
                }
            }
            
            Button("Delete all") {
                deleteAllGrades()
            }
            
//            Group {
//                switch vm.state {
//                case .success:
//                    VStack {
//
//
////                        GradesView(
////                            vm: self.vm
////                        )
//    //                    .refreshable {
//    //                        await vm.getGrades(forcedRefresh: true)
//    //                    }
//                    }
//                case .loading, .na:
//                    LoadingView(text: "Fetching Grades")
//                case .failed(let error):
//                    FailedView(
//                        errorDescription: error.localizedDescription,
//                        retryClosure: vm.getGrades
//                    )
//                }
//            }
        }
        
//        .task {
//            await vm.getGrades()
//        }
//        // Refresh whenever user authentication status changes
//        .onChange(of: self.refresh) { _ in
//            Task {
//                await vm.getGrades()
//            }
//        }
//        // As LoginView is just a sheet displayed in front of the GradeScreen
//        // Listen to changes on the token, then fetch the grades
//        .onChange(of: self.vm.token ?? "") { _ in
//            Task {
//                await vm.getGrades()
//            }
//        }
//        .alert(
//            "Error while fetching Grades",
//            isPresented: $vm.hasError,
//            presenting: vm.state) { detail in
//                Button("Retry") {
//                    Task {
//                        await vm.getGrades(forcedRefresh: true)
//                    }
//                }
//
//                Button("Cancel", role: .cancel) { }
//            } message: { detail in
//                if case let .failed(error) = detail {
//                    if let campusOnlineError = error as? TUMOnlineAPIError {
//                        Text(campusOnlineError.errorDescription ?? "CampusOnline Error")
//                    } else {
//                        Text(error.localizedDescription)
//                    }
//                }
//            }
    }
    
    func deleteAllGrades() {
        for grade in grades {
            moc.delete(grade)
        }
        
        try? moc.save()
    }
}

struct GradesScreen_Previews: PreviewProvider {
    static var previews: some View {
        GradesScreen(model: MockModel(), refresh: .constant(false), context: PersistenceController.shared.container.viewContext)
    }
}





