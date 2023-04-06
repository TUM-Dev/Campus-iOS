//
//  RoomFinderSearchViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 13.01.23.
//

import Foundation

extension RoomFinderSearchResultViewModel {
    enum State {
        case na
        case loading
        case success(data: [FoundRoom])
        case failed(error: Error)
    }
}

@MainActor
class RoomFinderSearchResultViewModel: ObservableObject {
    @Published var state: State = .na
    @Published var hasError: Bool = false
    
    func roomFinderSearch(for query: String, forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.state = .loading
        }
        self.hasError = false

        do {
            self.state = .success(data: try await RoomFinderSearchService().fetch(for: query, forcedRefresh: forcedRefresh))
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
