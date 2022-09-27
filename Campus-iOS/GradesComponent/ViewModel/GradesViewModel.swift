//
//  GradesViewModel.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation
import SwiftUI

protocol GradesViewModelProtocol: ObservableObject {
    func getGrades(forcedRefresh: Bool) async
}

@MainActor
class GradesViewModel: GradesViewModelProtocol {
    @Published var state: State = .na
    @Published var hasError: Bool = false
    
    private let model: Model
    private let service: GradesServiceProtocol
    
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
    
    var gradesByDegreeAndSemester: [(String, [(String, [Grade])])] {
        guard case .success(let data) = self.state else {
            return []
        }
        
        let gradesByDegree = data.reduce(into: [String: [Grade]]()) { partialResult, grade in
            if partialResult[grade.studyID] == nil {
                partialResult[grade.studyID] = [grade]
            } else {
                partialResult[grade.studyID]?.append(grade)
            }
        }
        
        let gradesByDegreeAndSemester = gradesByDegree.mapValues { grades in
            grades.reduce(into: [String: [Grade]]()) { partialResult, grade in
                if partialResult[grade.semester] == nil {
                    partialResult[grade.semester] = [grade]
                } else {
                    partialResult[grade.semester]?.append(grade)
                }
            }
        }
        
        return gradesByDegreeAndSemester
            .mapValues { gradesBySemester in
                gradesBySemester.compactMap { semester, grades in
                    (semester, grades)
                }
                .sorted { semesterA, semesterB in
                    semesterA.0 > semesterB.0
                }
                .compactMap { grade in
                    (Self.toFullSemesterName(grade.0), grade.1)
                }
            }
            .compactMap { degree, gradesBySemester in
                (degree, gradesBySemester)
            }
            .sorted { degreeA, degreeB in
                degreeA.0 < degreeB.0
            }
    }
    
    init(model: Model, service: GradesServiceProtocol) {
        self.model = model
        self.service = service
    }
    
    func getGrades(forcedRefresh: Bool = false) async {
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
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
    
    func getStudyProgram(studyID: String) -> String {
        guard case .success(let data) = self.state else {
            return ""
        }
        
        let studyDesignation = data.first { grade in
            grade.studyID == studyID
        }?.studyDesignation ?? ""
        
        return "\(studyDesignation) \(Self.getAcademicDegree(studyID: studyID).short) (\(studyID))"
    }
    
    private static func getAcademicDegree(studyID: String) -> AcademicDegree {
        let splitDegreeNumbers = studyID.split(separator: " ")
        
        guard splitDegreeNumbers.count == 3 else {
            return .unknown
        }
        
        let academicDegreeNumber = splitDegreeNumbers[1]
        
        switch academicDegreeNumber {
        case "04", "05", "06", "07": return .PhD
        case "14", "19": return .BE
        case "16", "20", "28": return .MSc
        case "17": return .BSc
        case "18": return .MBA
        case "29": return .MA
        case "30": return .BA
        case "37", "38", "39", "42": return .ME
        case "53": return .MBD
        case "60": return .BECE
        case "61": return .BEEDE
        default: return .unknown
        }
    }
}

private extension GradesViewModel {
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
