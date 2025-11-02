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
    private var valueSpecifier: String
    
    public init(
        type: BodyweightChartType,
        chartHeight: CGFloat,
        valueSpecifier: String = "%.1f"
    ) {
        self.type = type
        self.chartHeight = chartHeight
        self.valueSpecifier = valueSpecifier
    }
    
    public var body: some View {
        ModernLineChart(
            data: self.getData(),
            chartHeight: self.chartHeight,
            valueSpecifier: valueSpecifier
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
