//
//  BarChartView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 24.12.21.
//

import SwiftUI
import SwiftUICharts

struct BarChartView: View {
    var barChartData: BarChartData
    
    var body: some View {
        GroupBox {
            BarChart(chartData: barChartData)
                .xAxisGrid(chartData: barChartData)
                //.yAxisGrid(chartData: vm.barChartData)
                .xAxisLabels(chartData: barChartData)
                .yAxisLabels(chartData: barChartData)
                //.legends(chartData: barChartData)
                .frame(height: UIScreen.main.bounds.size.height/5, alignment: .center)
                .padding(.top, 12)
        }
        .padding(.horizontal)
        //.padding(.horizontal, 8)
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(
            barChartData:
                .init(
                    dataSets: .init(dataPoints: [])
                )
        )
    }
}
