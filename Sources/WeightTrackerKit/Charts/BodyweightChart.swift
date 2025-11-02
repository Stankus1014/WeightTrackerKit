//
//  BodyweightChart.swift
//  WeightTrackerKit
//
//  Created by William Stankus on 11/1/25.
//
import SwiftUI
import ModernCharts

public struct BodyweightChart: View {
    
    @StateObject private var dataManager = DataManager.shared
    private var chartHeight: CGFloat
    private var type: BodyweightChartType
    
    public init(
        type: BodyweightChartType,
        chartHeight: CGFloat
    ) {
        self.type = type
        self.chartHeight = chartHeight
    }
    
    public var body: some View {
        ModernLineChart(
            data: self.getData(),
            chartHeight: self.chartHeight
        )
    }
    
    private func getData() -> Binding<ChartData> {
        switch self.type {
        case .currentMonth:
            return $dataManager.currentMonthData
        case .previousTwoWeeks:
            return $dataManager.twoWeekData
        }
    }
}

public enum BodyweightChartType {
    case previousTwoWeeks
    case currentMonth
}

#Preview {
    BodyweightChart(type: .previousTwoWeeks, chartHeight: 400)
}
