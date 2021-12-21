//
//  GradesViewModel.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation

protocol LecturesViewModelProtocol: ObservableObject {
    func getLectures(token: String) async
}

@MainActor
class LecturesViewModel: LecturesViewModelProtocol {
    @Published private(set) var lectures: [Lecture] = []
    
    private let service: LecturesServiceProtocol
    
    init(serivce: LecturesServiceProtocol) {
        self.service = serivce
    }
    
    func getLectures(token: String) async {
        do {
            self.lectures = try await service.fetch(token: token)
        } catch {
            print(error)
        }
    }
}
