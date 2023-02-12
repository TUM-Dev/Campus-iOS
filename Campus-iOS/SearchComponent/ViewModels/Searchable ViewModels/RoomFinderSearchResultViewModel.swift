//
//  RoomFinderSearchViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 13.01.23.
//

import Foundation

@MainActor
class RoomFinderSearchResultViewModel: ObservableObject {
    @Published var results = [FoundRoom]()
    
    func roomFinderSearch(for query: String) async {
        guard let rooms = await fetch(for: query) else {
            results = []
            return
        }
        
        results = rooms
    }
    
    func fetch(for query: String) async -> [FoundRoom]? {
        do {
            return try await TUMCabeAPI.makeRequest(endpoint: .roomSearch(query: query))
        } catch {
            print("No rooms were fetched: \(String(describing: error))")
            return nil
        }
    }
    
}
