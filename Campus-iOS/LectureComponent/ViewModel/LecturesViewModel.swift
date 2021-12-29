//
//  GradesViewModel.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation

protocol LecturesViewModelProtocol: ObservableObject {
    func getLectures(token: String, forcedRefresh: Bool) async
}

@MainActor
class LecturesViewModel: LecturesViewModelProtocol {
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    
    private let service: LecturesServiceProtocol
    
    private var lecturesBySemester: [String: [Lecture]] {
        guard case .success(let data) = self.state else {
            return [:]
        }
        
        return data.reduce(into: [String: [Lecture]]()) { partialResult, lecture in
            if partialResult[lecture.semesterID] == nil {
                partialResult[lecture.semesterID] = [lecture]
            } else {
                partialResult[lecture.semesterID]?.append(lecture)
            }
        }
    }
    
    var sortedLecturesBySemester: [(String, [Lecture])] {
        self.lecturesBySemester
            .compactMap { semester, lectures in
                (semester, lectures)
            }
            .sorted { elementA, elementB in
				elementA.0 > elementB.0
            }
    }
    
    init(serivce: LecturesServiceProtocol) {
        self.service = serivce
    }
    
    func getLectures(token: String, forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.state = .loading
        }
        self.hasError = false
        
        do {
            self.state = .success(
                data: try await service.fetch(token: token, forcedRefresh: forcedRefresh)
            )
        } catch {
            print(error)
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
