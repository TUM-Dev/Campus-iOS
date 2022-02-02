//
//  GradesViewModel.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation
import SwiftUI

protocol GradesViewModelProtocol: ObservableObject {
    func getGrades(token: String, forcedRefresh: Bool) async
}

@MainActor
class GradesViewModel: GradesViewModelProtocol {
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    
    private let service: GradesServiceProtocol
    
    private var gradesBySemester: [String: [Grade]] {
        guard case .success(let data) = self.state else {
            return [:]
        }
        
        return data.reduce(into: [String: [Grade]]()) { partialResult, grade in
            if partialResult[grade.semester] == nil {
                partialResult[grade.semester] = [grade]
            } else {
                partialResult[grade.semester]?.append(grade)
            }
        }
    }
    
    var sortedGradesBySemester: [(String, [Grade])] {
        let test = self.gradesBySemester
            .compactMap { semester, grades in
                (semester, grades)
            }
            .sorted { elementA, elementB in
                elementA.0 > elementB.0
            }
            .compactMap { grade in
                (Self.toFullSemesterName(grade.0), grade.1)
            }
        
        return test
    }
    
    init(serivce: GradesServiceProtocol) {
        self.service = serivce
    }
    
    func getGrades(token: String, forcedRefresh: Bool = false) async {
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

private extension GradesViewModel {
    static func toFullSemesterName(_ semester: String) -> String {
        let year = "20\(String(semester.prefix(2)))"
        let nextYearShort = String((Int(year) ?? 2000) + 1).suffix(2)

        switch semester.last {
        case "W": return "Wintersemester \(year)/\(nextYearShort)"
        case "S": return "Sommersemester \(year)"
        default: return "Unknown"
        }
    }
}
