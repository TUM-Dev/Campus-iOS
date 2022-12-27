//
//  CafeteriaSearchResultViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import Foundation

@MainActor
class CafeteriasSearchResultViewModel: ObservableObject {
    
    @Published var results = [(cafeteria: Cafeteria, distance: Int)]()
    private let cafeteriaService: CafeteriasServiceProtocol = CafeteriasService()
    
    
    func cafeteriasSearch(for query: String) async {
        
        let cafeterias = await fetch()
        
        if let optionalResults = GlobalSearch.tokenSearch(for: query, in: cafeterias) {
            
            self.results = optionalResults
        }
    }
    
    func fetch() async -> [Cafeteria] {
        var cafeterias = [Cafeteria]()
        do {
            cafeterias = try await cafeteriaService.fetch(forcedRefresh: false)
            return cafeterias
        } catch {
            print("No cafeterias were fetched")
        }
        
        return cafeterias
    }
}
