//
//  CafeteriaSearchResultViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import Foundation

extension CafeteriaSearchResultViewModel {
    enum State {
        case na
        case loading
        case success(data: [(cafeteria: Cafeteria, distances: Distances)])
        case failed(error: Error)
    }
}

@MainActor
class CafeteriaSearchResultViewModel: ObservableObject {
    
    @Published var state: State = .na
    @Published var hasError: Bool = false
    let service: CafeteriasServiceProtocol
    
    init(service: CafeteriasServiceProtocol) {
        self.service = service
    }
    
    func cafeteriasSearch(for query: String, forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.state = .loading
        }
        self.hasError = false

        do {
            let data = try await service.fetch(forcedRefresh: forcedRefresh)
            if let optionalResults = GlobalSearch.tokenSearch(for: query, in: data) {
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
