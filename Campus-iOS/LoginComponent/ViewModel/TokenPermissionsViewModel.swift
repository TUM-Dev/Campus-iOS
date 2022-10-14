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
            .identification: .na]
    
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
        //let permissionModels = [GradesService(), LecturesService(), CalendarViewModel(model: self.model), ProfileViewModel(model: self.model)] as [Any]
        
        guard let token = self.token else {
//                self.state = .failed(error: NetworkingError.unauthorized)
//                self.hasError = true
            return
        }
        for type in types {
            switch type {
            case .grades:
                do {
                    self.states[.grades] = .success(
                        data: try await GradesService().fetch(token: token, forcedRefresh: true))
                } catch {
                    self.states[.grades] = .failed(error: error)
                    print(error)
                }
            case .calendar:
                let calenderVM = CalendarViewModel(model: self.model)
                
                calenderVM.fetch { result in
                    print(result)
                    if case let .success(data) = result {
                        print("Success")
                        self.states[.calendar] = .success(data: data)
                    } else {
                        print("no success")
                        self.states[.calendar] = .failed(error: CampusOnlineAPI.Error.noPermission)
                    }
                }
                
            case .lectures:
                do {
                    self.states[.lectures] = .success(
                        data: try await LecturesService().fetch(token: token, forcedRefresh: true))
                } catch {
                    self.states[.lectures] = .failed(error: error)
                    print(error)
                }
            case .tuitionFees:
                
                let profileVM = ProfileViewModel(model: self.model)
                profileVM.fetch()
                profileVM.checkTuitionFunc() {  result in
                    print(result)
                    if case let .success(data) = result {
                        print("Success")
                        self.states[.tuitionFees] = .success(data: data)
                    } else {
                        print("no success")
                        self.states[.tuitionFees] = .failed(error: CampusOnlineAPI.Error.noPermission)
                    }
                }
                
            case .identification:
                
                let profileVM = ProfileViewModel(model: self.model)
                profileVM.fetch() {  result in
                    print(result)
                    if case let .success(data) = result {
                        print("Success")
                        self.states[.identification] = .success(data: data)
                    } else {
                        print("no success")
                        self.states[.identification] = .failed(error: CampusOnlineAPI.Error.noPermission)
                    }
                }
            }
        }
            
    }
}

extension TokenPermissionsViewModel {
    enum State {
        case na
        case loading
        case success(data: Any?)
        case failed(error: Error)
    }
    
    enum PermissionType {
        case grades
        case calendar
        case lectures
        case tuitionFees
        case identification
    }
}
