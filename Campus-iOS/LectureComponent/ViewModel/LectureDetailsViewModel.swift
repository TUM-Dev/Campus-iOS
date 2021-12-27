//
//  LectureDetailsViewModel.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 25.12.21.
//

import Foundation

protocol LectureDetailsViewModelProtocol: ObservableObject {
    func getLectureDetails(token: String, lvNr: UInt64) async
}

@MainActor
class LectureDetailsViewModel: LectureDetailsViewModelProtocol {
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    
    private let service: LectureDetailsServiceProtocol
    
    init(serivce: LectureDetailsServiceProtocol) {
        self.service = serivce
    }
    
    func getLectureDetails(token: String, lvNr: UInt64) async {
        self.state = .loading
        self.hasError = false
        
        do {
            self.state = .success(
                data: try await service.fetch(token: token, lvNr: lvNr)
            )
        } catch {
            print(error)
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
