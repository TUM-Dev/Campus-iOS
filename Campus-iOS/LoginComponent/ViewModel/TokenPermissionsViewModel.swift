//
//  TokenPermissionsViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 14.10.22.
//

import Foundation

@MainActor
class TokenPermissionsViewModel: ObservableObject {
    
    @Published var state: State = .na
    
    let service = GradesService()
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
    
    func checkPermissionFor(type: PermissionType) async {
        guard let token = self.token else {
//                self.state = .failed(error: NetworkingError.unauthorized)
//                self.hasError = true
            return
        }
        
        do {
            self.state = .success(
                data: try await service.fetch(token: token, forcedRefresh: true))
        } catch {
            self.state = .failed(error: error)
            print(error)
        }
    }
}

extension TokenPermissionsViewModel {
    enum State {
        case na
        case loading
        case success(data: [Grade])
        case failed(error: Error)
    }
    
    enum PermissionType {
        case grades
        case calendar
        case lectures
        case studyFees
        case identification
    }
}
