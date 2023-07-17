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
    func getAverageGrades(forcedRefresh: Bool) async
}

@MainActor
class GradesViewModel: GradesViewModelProtocol {
    @Published var gradesState: APIState<[Grade]> = .na
    @Published var hasError: Bool = false
    @Published var averageGradesState: APIState<[AverageGrade]> = .na
    
    let model: Model
    private let gradesService: GradesService
    private let averageGradesService: AverageGradesService
    
    init(model: Model, gradesService: GradesService, averageGradesService: AverageGradesService) {
        self.model = model
        self.gradesService = gradesService
        self.averageGradesService = averageGradesService
    }
    
    var state: APIState<GradesAndAverageGrades> {
        switch (gradesState, averageGradesState) {
        case (.success(let grades), .success(let averageGrades)):
            return .success(data: GradesAndAverageGrades(grades: grades, averageGrades: averageGrades))
        case (_, .loading),
            (.loading, _):
            return .loading
        case (_, .failed(let error)),
            (.failed(let error), _):
            return .failed(error: error)
        default:
            return .na
        }
    }
    
    struct GradesAndAverageGrades: Decodable {
        let grades: [Grade]
        let averageGrades: [AverageGrade]
    }
    
    struct GradesByDegreeAndSemesterWithAverageGrade {
        let degree: String
        let averageGrade: AverageGrade?
        let semester: [String: [Grade]]
    }
    
    var gradesByDegreeAndSemesterWithAverageGrade: [GradesByDegreeAndSemesterWithAverageGrade] {
        guard case .success(let data) = self.state else {
            return []
        }
        
        let grades = data.grades
        let averageGrades = data.averageGrades
        
        let gradesByDegree = grades.reduce(into: [String: [Grade]]()) { partialResult, grade in
            if partialResult[grade.studyID] == nil {
                partialResult[grade.studyID] = [grade]
            } else {
                partialResult[grade.studyID]?.append(grade)
            }
        }
        
        let averageGradesByDegree = averageGrades.reduce(into: [String: AverageGrade]()) { partialResult, avgGrade in
            partialResult[avgGrade.studyId] = avgGrade
        }
        
        let gradesByDegreeAndSemester = gradesByDegree.mapValues { grades in
            grades.reduce(into: [String: [Grade]]()) { partialResult, grade in
                let semesterName = grade.semester
                if partialResult[semesterName] == nil {
                    partialResult[semesterName] = [grade]
                } else {
                    partialResult[semesterName]?.append(grade)
                }
            }
        }
        
        return gradesByDegreeAndSemester.map { key, value in
            GradesByDegreeAndSemesterWithAverageGrade(degree: key, averageGrade: averageGradesByDegree[key], semester: value
            )
        }.sorted {
            $0.degree < $1.degree
        }
    }
    
    var grades: [Grade] {
        guard case .success(let data) = self.gradesState else {
            return []
        }
        
        return data.sorted { gradeA, gradeB in
            return gradeA.date > gradeB.date
        }
    }
    
    func getGrades(forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.gradesState = .loading
        }
        self.hasError = false
        
        guard let token = self.model.token else {
            self.gradesState = .failed(error: NetworkingError.unauthorized)
            self.hasError = true
            return
        }
        
        do {
            self.gradesState = .success(
                data: try await gradesService.fetch(token: token, forcedRefresh: forcedRefresh)
            )
        } catch {
            self.gradesState = .failed(error: error)
            self.hasError = true
        }
    }
    
    func getAverageGrades(forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.averageGradesState = .loading
        }
        
        guard let token = self.model.token else {
            self.averageGradesState = .failed(error: NetworkingError.unauthorized)
            self.hasError = true
            return
        }
        
        do {
            self.averageGradesState = .success(
                data: try await averageGradesService.fetch(token: token, forcedRefresh: forcedRefresh)
            )
        } catch {
            self.averageGradesState = .failed(error: error)
            self.hasError = true
        }
    }
    
    func reloadGradesAndAverageGrades(forcedRefresh: Bool = false) async {
        await getGrades(forcedRefresh: forcedRefresh)
        await getAverageGrades(forcedRefresh: forcedRefresh)
    }
    
    func getStudyProgram(studyID: String) -> String {
        guard case .success(let data) = self.state else {
            return ""
        }
        
        let studyDesignation = data.grades.first { grade in
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

extension GradesViewModel {
    static var previewGradesSemesterDegree: GradesSemesterDegrees {
        return Self.gradesByDegreeAndSemester(data: Grade.previewData)
    }
}
