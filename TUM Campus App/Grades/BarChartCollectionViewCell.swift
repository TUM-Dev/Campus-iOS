//
//  BarChartCollectionViewCell.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 25.6.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import Charts

final class GradeChartCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var barChartView: BarChartView!
    private var animate: Bool = true

    func configure(chartViewModel: GradeChartViewModel.Chart) {
        barChartView.data = chartViewModel.chartData

        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = IndexAxisValueFormatter(values: chartViewModel.gradeStrings)

        let leftAxis = barChartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = false
        leftAxis.granularity = 1.0

        let rightAxis = barChartView.rightAxis
        rightAxis.enabled = false

        let legend = barChartView.legend
        legend.enabled = false

        if animate {
            barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInOutSine)
        }
        barChartView.drawGridBackgroundEnabled = false
        barChartView.fitBars = true
        barChartView.isUserInteractionEnabled = false
        barChartView.drawValueAboveBarEnabled = true
    }

    override func prepareForReuse() {
        animate = false
    }
}
