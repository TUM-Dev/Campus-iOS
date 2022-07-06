//
//  LectureDetailsViewModel.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 25.12.21.
//

import Foundation

protocol LectureDetailsViewModelProtocol: ObservableObject {
    func getLectureDetails(forcedRefresh: Bool) async
}

@MainActor
class LectureDetailsViewModel: LectureDetailsViewModelProtocol {
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    
    let model: Model
    private let service: LectureDetailsServiceProtocol?
    private let lecture: Lecture?
    
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
    
    init(model: Model, service: LectureDetailsServiceProtocol, lecture: Lecture) {
        self.model = model
        self.service = service
        self.lecture = lecture
    }
    
    init(model: Model) {
        self.model = model
        self.service = nil
        self.lecture = nil
    }
    
    func getLectureDetails(forcedRefresh: Bool = false) async {
        self.state = .loading
        self.hasError = false
        
        guard let token = self.token else {
            self.state = .failed(error: NetworkingError.unauthorized)
            self.hasError = true
            return
        }
        
        if let service = service, let lecture = lecture {
            do {
                self.state = .success(
                    data: try await service.fetch(token: token, lvNr: lecture.id, forcedRefresh: forcedRefresh)
                )
            } catch {
                print(error)
                self.state = .failed(error: error)
                self.hasError = true
            }
        }
    }
}
