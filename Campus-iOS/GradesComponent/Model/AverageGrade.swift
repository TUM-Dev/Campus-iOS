//
//  AverageGrade.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 08.05.23.
//

import Foundation

struct AverageGradeStudien: Decodable {
    let studium: [AverageGrade]
}

struct AverageGrade: Decodable, Identifiable {
    public var id: String {
        "\(studyId)-\(averageGradeWeightedByCredits)"
    }
    public var studyId: String
    public var studyDesignation: String
    public var averageGradeWeightedByCredits: String
    
    public var averageGradeRounded: String {
        let doubleValue = Double(averageGradeWeightedByCredits.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        return String(format: "%.2f", doubleValue)
    }
    
    enum CodingKeys: String, CodingKey {
        case studyId = "studidf"
        case studyDesignation = "studbez"
        case averageGradeWeightedByCredits = "avg_grade_weighted_by_credits"
    }
}

extension AverageGrade {
    static let dummyData: [AverageGrade] = [
        AverageGrade(studyId: "1630 17 030", studyDesignation: "Informatik", averageGradeWeightedByCredits: "1,777")
    ]
}
