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
        
        let accumulatedGrades = data.reduce(into: [String: Double]()) { partialResult, grade in
            if partialResult[grade.grade] == nil {
                partialResult[grade.grade] = 0
            }
            partialResult[grade.grade]! += 1
        }
        .compactMap { key, value in
            (key, value)
        }
        .sorted { $0.0 < $1.0 }
        
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
            /*
            yAxisLabels: Array(Set(accumulatedGrades.compactMap { key, value in
                String(value)
            })).sorted(),
             */
            barStyle: .init(
                barWidth: 0.8,
                cornerRadius: CornerRadius(top: 2, bottom: 0),
                colourFrom: .dataPoints,
                colour: ColourStyle(colour: .gray)
            ),
            chartStyle: .init(
                xAxisLabelsFrom: .chartData(rotation: .zero),
                yAxisNumberOfLabels: 5,
                baseline: .zero,
                topLine: .maximum(
                    of: accumulatedGrades.max(by: { gradeA, gradeB in
                            gradeA.1 > gradeB.1
                        })?.1 ?? 0
                ),
                //yAxisLabelType: .custom,
                globalAnimation: .easeInOut(duration: 0.8)
            )
        )
    }
}
