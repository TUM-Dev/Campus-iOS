//
//  PersonSearchResultViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 14.01.23.
//

import Foundation

@MainActor
class PersonSearchResultViewModel: ObservableObject {
    @Published var results = [Person]()
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
    
    func personSearch(for query: String) async {
        guard let lectures = await fetch(for: query) else {
            return
        }
        
        results = lectures
    }
    
    func fetch(for query: String) async -> [Person]? {
        do {
            return try await TUMOnlineAPI.makeRequest(endpoint: .personSearch(search: query), token: self.token)
        } catch {
            print("No lectures were fetched: \(String(describing: error))")
            return nil
        }
    }
    
}
