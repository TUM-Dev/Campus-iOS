//
//  GradesViewModel+ChartData.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 25.12.21.
//

import Foundation
import SwiftUICharts

extension GradesViewModel {
    var barChartData: BarChartData {
        guard case .success(let data) = self.state else {
            return .init(
                dataSets: .init(dataPoints: [])
            )
        }
        
        var accumulatedGrades = data.reduce(into: [String: Double]()) { partialResult, grade in
            if partialResult[grade.grade] == nil {
                partialResult[grade.grade] = 0
            }
            partialResult[grade.grade]! += 1
        }
        .compactMap { key, value in
            (key, value)
        }
        .sorted { $0.0 < $1.0 }
        
        // Push "info grades" to the back of the array
        if let firstElement = accumulatedGrades.first,
           firstElement.0 == "" {
            accumulatedGrades.rearrange(from: 0, to: accumulatedGrades.count-1)
        }
        
        return .init(
            dataSets: .init(
                dataPoints: accumulatedGrades.compactMap { key, value in
                    .init(value: value, xAxisLabel: key.replacingOccurrences(of: ",", with: "."), colour: .init(
                            colour: Self.GradeColor.color(
                                for: Double(key.replacingOccurrences(of: ",", with: "."))   // Convert german to english notation
                            )
                        )
                    )
                }
            ),
            xAxisLabels: accumulatedGrades.compactMap { key, value in
                key
            },
            yAxisLabels: Array(Set(accumulatedGrades.compactMap { key, value in
                String(value)
            })).sorted(),
            barStyle: .init(
                barWidth: 0.8,
                cornerRadius: CornerRadius(top: 2, bottom: 0),
                colourFrom: .dataPoints,
                colour: ColourStyle(colour: .gray)
            ),
            chartStyle: .init(
                yAxisNumberOfLabels: 5,
                baseline: .zero,
				topLine: .maximumValue,
                //yAxisLabelType: .custom,
                globalAnimation: .easeInOut(duration: 0.8)
            )
        )
    }
}

