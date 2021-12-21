//
//  GradesViewModel.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation

protocol GradesViewModelProtocol: ObservableObject {
    func getGrades(token: String) async
}

@MainActor
class GradesViewModel: GradesViewModelProtocol {
    @Published private(set) var grades: [Grade] = []
    
    private let service: GradesServiceProtocol
    
    init(serivce: GradesServiceProtocol) {
        self.service = serivce
    }
    
    func getGrades(token: String) async {
        do {
            self.grades = try await service.fetch(token: token)
        } catch {
            print(error)
        }
    }
}
