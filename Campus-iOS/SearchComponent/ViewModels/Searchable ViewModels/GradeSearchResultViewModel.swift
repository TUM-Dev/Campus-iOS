//
//  GradeSearchResultViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import SwiftUI

extension GradesSearchResultViewModel {
    enum State {
        case na
        case loading
        case success(data: [(grade: Grade, distance: Distances)])
        case failed(error: Error)
    }
}

@MainActor
class GradesSearchResultViewModel: ObservableObject {
    @Published var results = [(grade: Grade, distance: Distances)]()
    @Published var state: State = .na
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
    
//    func gradesSearch(for query: String) async {
//        guard let grades = try await fetch
//
//        if let optionalResults = GlobalSearch.tokenSearch(for: query, in: servi) {
//            self.results = optionalResults
//
//            #if DEBUG
////            print(">>> \(query)")
////            optionalResults.forEach { result in
////                print(result.0)
////                print(result.1)
////            }
//            #endif
//        }
//    }
    
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
                self.results = optionalResults
                
                self.state = .success(data: optionalResults)
            } else {
                self.state = .failed(error: SearchError.empty(searchQuery: query))
            }
            
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}

enum SearchError: Error {
    case empty(searchQuery: String)
    case unexpected
}

extension SearchError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty(let searchQuery):
            return "No search results were found for: \"\(searchQuery)\"."
        case .unexpected:
            return "An unexpected error occurred."
        }
    }
}
