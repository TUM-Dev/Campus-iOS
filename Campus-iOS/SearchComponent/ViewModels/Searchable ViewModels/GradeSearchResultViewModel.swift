//
//  GradeSearchResultViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import SwiftUI

@MainActor
class GradesSearchResultViewModel: ObservableObject {
    @Published var state: SearchState<Grade> = .na
    @Published var hasError: Bool = false
    
    let model: Model
    let service: GradesServiceProtocol
    
    init(model: Model, service: GradesServiceProtocol) {
        self.model = model
        self.service = service
    }
    
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
    
    func gradesSearch(for query: String, forcedRefresh: Bool = false) async {
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
            let data = try await service.fetch(token: token, forcedRefresh: forcedRefresh)
            if let optionalResults = GlobalSearch.tokenSearch(for: query, in: data) {
                self.state = .success(data: optionalResults)
            } else {
                self.state = .failed(error: SearchError.empty(searchQuery: query))
                self.hasError = true
            }
            
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
