//
//  GradeSearchResultViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import SwiftUI

class GradesSearchResultViewModel: ObservableObject {
    @ObservedObject var vm: GradesViewModel
    @Published var results = [(grade: Grade, distance: Distances)]()
    
    init(model: Model) {
        self.vm = GradesViewModel(model: model, service: GradesService())
    }
    
    func gradesSearch(for query: String) async {
        await fetch()
        
        if let optionalResults = GlobalSearch.tokenSearch(for: query, in: vm.grades) {
            self.results = optionalResults
            
            #if DEBUG
//            print(">>> \(query)")
//            optionalResults.forEach { result in
//                print(result.0)
//                print(result.1)
//            }
            #endif
        }
    }
    
    func fetch() async {
        await vm.getGrades()
    }
}
