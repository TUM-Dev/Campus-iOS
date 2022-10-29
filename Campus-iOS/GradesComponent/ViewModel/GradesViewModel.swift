//
//  GradesViewModel.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation
//import SwiftUI
import XMLCoder
import CoreData

protocol GradesViewModelProtocol: ObservableObject {
    func getGrades(forcedRefresh: Bool) async
}

@MainActor
class GradesViewModel: GradesViewModelProtocol {
    
//    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(sortDescriptors: []) var gradesCD: FetchedResults<Grade>
    
    var grades: [Grade] = []
    
    let moc: NSManagedObjectContext
    
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
        guard case .success = self.state else {
            return []
        }
        
        let gradesByDegree = grades.reduce(into: [String: [Grade]]()) { partialResult, grade in
            guard let studyID = grade.studyID else {
                return
            }
            
            if partialResult[studyID] == nil {
                partialResult[studyID] = [grade]
            } else {
                partialResult[studyID]?.append(grade)
            }
        }
        
        let gradesByDegreeAndSemester = gradesByDegree.mapValues { grades in
            grades.reduce(into: [String: [Grade]]()) { partialResult, grade in
                guard let semester = grade.semester else {
                    return
                }
                
                if partialResult[semester] == nil {
                    partialResult[semester] = [grade]
                } else {
                    partialResult[semester]?.append(grade)
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
    
    var preparedGrades: [Grade] {
        return gradesByDegreeAndSemester.flatMap { (degree, gradesBySemester) in
            return gradesBySemester.flatMap { (semester, grades) in
                return grades
            }
        }
        .sorted { gradeA, gradeB in
            let dateA = gradeA.date ?? Date.distantPast
            let dateB = gradeB.date ?? Date.distantPast
            return dateA > dateB
        }
    }
    
    init(model: Model, service: GradesServiceProtocol, context: NSManagedObjectContext) {
        self.model = model
        self.service = service
        self.moc = context
    }
    
    static let decoder: XMLDecoder = {
        let decoder = XMLDecoder()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }()
    
    func fetchGrades() async throws {
        var data: Data
        do {
            data = try await Constants.API.CampusOnline.personalGrades.asRequest(token: token).serializingData().value
        } catch {
            print(error)
            throw NetworkingError.deviceIsOffline
        }

        do {
            Self.decoder.userInfo[CodingUserInfoKey.managedObjectContext] = moc
            let newGradeSet = try Self.decoder.decode(RowSet<Grade>.self, from: data)

            let newGrades = newGradeSet.row

            for grade in newGrades {
                print(grade.title)
            }

            try moc.save()
            print("Saved")

            print("Count: \(newGrades.count)")
        } catch {
            print(error)
        }
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
            try await service.fetchCoreData(into: moc, token: token, forcedRefresh: false)
//            self.state = .success
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
    
    func getStudyProgram(studyID: String) -> String {
        guard case .success = self.state else {
            return ""
        }
        
        let studyDesignation = grades.first { grade in
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
