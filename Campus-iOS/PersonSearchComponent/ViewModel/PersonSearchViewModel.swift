//
//  PersonSearchViewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 06.02.22.
//

import Foundation
import Alamofire
import XMLCoder

@MainActor
class PersonSearchViewModel: ObservableObject {
    @Published var state: APIState<[Person]> = .na
    @Published var hasError: Bool = false
    
    let model: Model
    let service: PersonSearchService
    
    init(model: Model, service: PersonSearchService) {
        self.model = model
        self.service = service
    }
    
    func getPersons(for query: String, forcedRefresh: Bool) async {
        if !forcedRefresh {
            self.state = .loading
        }
        self.hasError = false

        guard let token = self.model.token else {
            self.state = .failed(error: NetworkingError.unauthorized)
            self.hasError = true
            return
        }
        
        do {
            self.state = .success(
                data: try await service.fetch(for: query, token: token, forcedRefresh: forcedRefresh)
            )
            
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
