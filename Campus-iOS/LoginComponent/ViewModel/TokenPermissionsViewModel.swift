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
                Task {
                    let calenderVM = CalendarViewModel(model: self.model)
                    calenderVM.fetch()
                    
                    switch calenderVM.state {
                        
                    case .na:
                        self.states[.calendar] = .na
                    case .loading:
                        self.states[.calendar] = .loading
                    case .success(data: let data):
                        self.states[.calendar] = .success(data: data)
                    case .failed(error: let error):
                        self.states[.calendar] = .failed(error: error)
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
                Task {
                    let profileVM = ProfileViewModel(model: self.model)
                    profileVM.fetch()
                    
                    switch profileVM.tuitionState {
                        
                    case .na:
                        self.states[.tuitionFees] = .na
                    case .loading:
                        self.states[.tuitionFees] = .loading
                    case .success(data: let data):
                        self.states[.tuitionFees] = .success(data: data)
                    case .failed(error: let error):
                        self.states[.tuitionFees] = .failed(error: error)
                    }
                }
            case .identification:
                Task {
                    let profileVM = ProfileViewModel(model: self.model)
                    profileVM.fetch()
                    
                    switch profileVM.profileState {
                        
                    case .na:
                        self.states[.identification] = .na
                    case .loading:
                        self.states[.identification] = .loading
                    case .success(data: let data):
                        self.states[.identification] = .success(data: data)
                    case .failed(error: let error):
                        self.states[.identification] = .failed(error: error)
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
