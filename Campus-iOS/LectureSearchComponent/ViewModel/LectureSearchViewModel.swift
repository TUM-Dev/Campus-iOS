//
//  LectureSearchViewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.02.22.
//

import Foundation

import Foundation
import Alamofire
import XMLCoder

@MainActor
class LectureSearchViewModel: ObservableObject {
    @Published var state: APIState<Lecture> = .na
    @Published var hasError: Bool = false
    
    let model: Model
    let service: LectureSearchService
    
    init(model: Model, service: LectureSearchService) {
        self.model = model
        self.service = service
    }
    
    func getLectures(for query: String, forcedRefresh: Bool) async {
        guard query.count > 3 else {
            // Since requests under 4 char is not allowed
            return
        }
        
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
