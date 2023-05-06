//
//  CafeteriaSearchResultViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import Foundation

@MainActor
class CafeteriaSearchResultViewModel: ObservableObject {
    
    @Published var state: SearchState<Cafeteria> = .na
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
