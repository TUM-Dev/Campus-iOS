//
//  TokenPermissionsViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 14.10.22.
//

import Foundation

@MainActor
class TokenPermissionsViewModel: ObservableObject {
    
    @Published var states: [PermissionType: State] = [
            .grades: .na,
            .calendar: .na,
            .lectures: .na,
            .tuitionFees: .na,
            .identification: .na
    ]
    
    let model: Model
    
    var token: String? {
        switch self.model.loginController.credentials {
        case .none, .noTumID:
            return nil
        case .tumID(_, let token):
            return token
        case .tumIDAndKey(_, let token, _):
            return token
        }
    }
    
    init(model: Model) {
        self.model = model
    }
    
    func checkPermissionFor(types: [PermissionType]) async {
        // Check if token is nil
        guard let token = self.token else {
            self.states.keys.forEach { type in
                states[type] = .failed(error: NetworkingError.unauthorized)
            }
            return
        }
        
        // Check for each permission type, e.g. grades if we have the necessary permissons, i.e. we are allowed to fetch data (here grades, etc.)
        for type in types {
            switch type {
            case .grades:
                do {
                    try await GradesService().fetch(into: PersistenceController.shared.container.viewContext, with: token)
                    self.states[.grades] = .success
                } catch {
                    self.states[.grades] = .failed(error: error)
                }
            case .calendar:
                let calenderVM = CalendarViewModel(model: self.model)
                
                calenderVM.fetch { result in
                    if case .success = result {
                        print("Success")
                        self.states[.calendar] = .success
                    } else {
                        print("No success")
                        self.states[.calendar] = .failed(error: TUMOnlineAPIError.noPermission)
                    }
                }
                
            case .lectures:
                do {
                    let _ = try await LecturesService().fetch(token: token, forcedRefresh: true)
                    self.states[.lectures] = .success
                } catch {
                    self.states[.lectures] = .failed(error: error)
                    print(error)
                }
            case .tuitionFees:
                
                let profileVM = ProfileViewModel(model: self.model)
                profileVM.fetch()
                profileVM.checkTuitionFunc() {  result in
                    print(result)
                    if case .success = result {
                        print("Success")
                        self.states[.tuitionFees] = .success
                    } else {
                        print("no success")
                        self.states[.tuitionFees] = .failed(error: TUMOnlineAPIError.noPermission)
                    }
                }
                
            case .identification:
                
                let profileVM = ProfileViewModel(model: self.model)
                profileVM.fetch() {  result in
                    print(result)
                    if case .success = result {
                        print("Success")
                        self.states[.identification] = .success
                    } else {
                        print("no success")
                        self.states[.identification] = .failed(error: TUMOnlineAPIError.noPermission)
                    }
                }
            }
        }
            
    }
}
