//
//  GradeChartViewModel.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 25.6.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import Charts

struct GradeChartViewModel: Hashable {
    let charts: [String: Chart]

    struct Chart: Hashable {
        let gradeStrings: [String]
        let chartData: BarChartData
    }


    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    init(grades: [Grade]) {
        let studies = Dictionary(grouping: grades) { (grade: Grade) -> String in
            return grade.studyID ?? ""
        }

        self.charts = studies.mapValues(GradeChartViewModel.generateChart(for:))
    }

    private static func generateChart(for grades: [Grade]) -> Chart {
        let gradeValues = grades.compactMap { Decimal(string: $0.grade?.replacingOccurrences(of: ",", with: ".") ?? "") }
        let gradeMap = gradeValues.reduce(into: [:]) { $0[$1] = ($0[$1] ?? 0) + 1 }.sorted { $0.key < $1.key }

        let gradeStrings: [String] = gradeMap.compactMap {
            let formatter = NumberFormatter()
            formatter.alwaysShowsDecimalSeparator = true
            formatter.minimumFractionDigits = 1
            formatter.maximumFractionDigits = 1
            return formatter.string(from: $0.key as NSDecimalNumber)
        }

        var dataEntries: [BarChartDataEntry] = []
        var colors: [UIColor] = []

        for grade in gradeMap.enumerated() {
            let entry = BarChartDataEntry(x: Double(grade.offset), y: Double(grade.element.value))
            dataEntries.append(entry)
            let grade = Double(truncating: grade.element.key as NSNumber)
            colors.append(GradeColor.color(for: grade))
        }

        let dataSet = BarChartDataSet(entries: dataEntries)
        dataSet.colors = colors
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)

        let chartData = BarChartData(dataSet: dataSet)

        return Chart(gradeStrings: gradeStrings, chartData: chartData)
    }

}
