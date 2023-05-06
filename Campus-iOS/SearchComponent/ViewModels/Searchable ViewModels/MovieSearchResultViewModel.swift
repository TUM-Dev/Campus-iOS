//
//  MovieSearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 07.03.23.
//

import Foundation

@MainActor
class MovieSearchResultViewModel: ObservableObject {
    @Published var state: SearchState<Movie> = .na
    @Published var hasError: Bool = false
    
    let service: MovieServiceProtocol
    
    init(service: MovieServiceProtocol) {
        self.service = service
    }
    
    func movieSearch(for query: String, forcedRefresh: Bool = false) async {
    
        if !forcedRefresh {
            self.state = .loading
        }
        self.hasError = false

        do {
            let data = try await service.fetch(forcedRefresh: forcedRefresh)
            let filteredMovies = data.filter { movie in
                return (movie.date ?? Date.distantPast) >= Date()
            }
            
            if let optionalResults = GlobalSearch.tokenSearch(for: query, in: filteredMovies) {
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

