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
                    self.states[.grades] = .success(
                        data: try await GradesService().fetch(token: token, forcedRefresh: true))
                } catch {
                    self.states[.grades] = .failed(error: error)
                }
            case .calendar:
                do {
                    self.states[.calendar] = .success(
                        data: try await CalendarService().fetch(token: token, forcedRefresh: true))
                } catch {
                    self.states[.calendar] = .failed(error: error)
                }
            case .lectures:
                do {
                    self.states[.lectures] = .success(
                        data: try await LecturesService().fetch(token: token, forcedRefresh: true))
                } catch {
                    self.states[.lectures] = .failed(error: error)
                }
            case .tuitionFees:
                do {
                    guard let tuitionFees: Tuition = try await ProfileService().fetch(token: token, forcedRefresh: true) else {
                        self.states[.identification] = .failed(error: TUMOnlineAPIError(message: "Tuition couldn't be loaded."))
                        break
                    }
                    
                    self.states[.tuitionFees] = .success(
                        data: tuitionFees)
                } catch {
                    self.states[.identification] = .failed(error: error)
                }
                
            case .identification:
                
                do {
                    guard let profile: Profile = try await ProfileService().fetch(token: token, forcedRefresh: true) else {
                        self.states[.identification] = .failed(error: TUMOnlineAPIError(message: "Tuition couldn't be loaded."))
                        break
                    }
                    
                    self.states[.identification] = .success(
                        data: profile)
                } catch {
                    self.states[.identification] = .failed(error: error)
                }
            }
        }
            
    }
}
