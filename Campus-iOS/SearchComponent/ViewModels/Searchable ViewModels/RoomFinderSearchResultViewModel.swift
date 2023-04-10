//
//  RoomFinderSearchViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 13.01.23.
//

import Foundation

@MainActor
class RoomFinderSearchResultViewModel: ObservableObject {
    @Published var state: APIState<[NavigaTumNavigationEntity]> = .na
    @Published var hasError: Bool = false
    
    func roomFinderSearch(for query: String, forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.state = .loading
        }
        self.hasError = false

        do {
            self.state = .success(data: try await RoomFinderService().search(query: query).sections.flatMap(\.entries))
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
