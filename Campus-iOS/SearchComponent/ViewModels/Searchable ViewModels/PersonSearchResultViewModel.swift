//
//  PersonSearchResultViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 14.01.23.
//

import Foundation

@MainActor
class PersonSearchResultViewModel: ObservableObject {
    @Published var state: APIState<[Person]> = .na
    @Published var hasError: Bool = false
    
    let model : Model
    
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
    
    func personSearch(for query: String, forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.state = .loading
        }
        self.hasError = false
        
        guard let token = self.token else {
            self.state = .failed(error: NetworkingError.unauthorized)
            self.hasError = true
            return
        }

        do {            
            self.state = .success(data: try await PersonSearchService().fetch(for: query, token: token, forcedRefresh: forcedRefresh))
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
