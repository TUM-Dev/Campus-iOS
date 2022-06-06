//
//  GradesViewModel.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation

protocol LecturesViewModelProtocol: ObservableObject {
    func getLectures(forcedRefresh: Bool) async
}

@MainActor
class LecturesViewModel: LecturesViewModelProtocol {
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    
    let model: Model
    private let service: LecturesServiceProtocol
    
    var token: String? {
        switch self.model.loginController.credentials {
        case .none, .noTumID:
            return nil
        case .tumID(_, let token):
            return token
        case .tumIDAndKey(_, let token, _):
            return token
        }
    }
    
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
            .compactMap { tupel in
                (Self.toFullSemesterName(tupel.0), tupel.1)
            }
    }
    
    init(model: Model, service: LecturesServiceProtocol) {
        self.model = model
        self.service = service
    }
    
    func getLectures(forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.state = .loading
        }
        self.hasError = false
        
        guard let token = self.token else {
            self.state = .failed(error: NetworkingError.unauthorized)
            self.hasError = true
            return
        }

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

private extension LecturesViewModel {
    static func toFullSemesterName(_ semester: String) -> String {
        let year = "20\(String(semester.prefix(2)))"
        let nextYearShort = String((Int(year) ?? 2000) + 1).suffix(2)

        switch semester.last {
        case "W": return "Wintersemester".localized + " \(year)/\(nextYearShort)"
        case "S": return "Summersemester".localized + " \(year)"
        default: return "Unknown".localized
        }
    }
}
