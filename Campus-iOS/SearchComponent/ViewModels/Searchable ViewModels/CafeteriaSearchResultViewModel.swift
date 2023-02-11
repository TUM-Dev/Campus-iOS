//
//  CafeteriaSearchResultViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import Foundation

@MainActor
class CafeteriasSearchResultViewModel: ObservableObject {
    
    @Published var results = [(cafeteria: Cafeteria, distances: Distances)]()
    let service: CafeteriasServiceProtocol
    
    init(service: CafeteriasServiceProtocol) {
        self.service = service
    }
    
    func cafeteriasSearch(for query: String) async {
        
        let cafeterias = await fetch()
        
        if let optionalResults = GlobalSearch.tokenSearch(for: query, in: cafeterias) {
            self.results = optionalResults
            
//            #if DEBUG
//            print(">>> \(query)")
//            optionalResults.forEach { result in
//                print(result.0)
//                print(result.1)
//            }
//            #endif
        }
    }
    
    func fetch() async -> [Cafeteria] {
        //TODO: Error handling instead of returning an empty array
        var cafeterias = [Cafeteria]()
        do {
            cafeterias = try await service.fetch(forcedRefresh: false)
            return cafeterias
        } catch {
            print("No cafeterias were fetched")
        }
        
        return cafeterias
    }
}
