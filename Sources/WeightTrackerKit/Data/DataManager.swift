//
//  DataManager.swift
//  WeightTrackerKit
//
//  Created by William Stankus on 10/30/25.
//

import SwiftUI
import ModernCharts

@MainActor
final class DataManager: ObservableObject {
    
    static let shared = DataManager()
    
    @Published var currentMonthData: ChartData = ChartData(dataPoints: [])
    @Published var twoWeekData: ChartData = ChartData(dataPoints: [(Date(),212.2)])
    
    private let synthesizer: DatapointSynthezier
    
    private init() {
        let properties = SynthezierProperties(fillAllXAxisLabels: false, ascendingDates: true)
        self.synthesizer = DatapointSynthezier(properties: properties)
        self.cacheData()
    }
    
    private func cacheData() {
        Task {
            self.currentMonthData = await loadCurrentMonthData()
            self.twoWeekData = await loadTwoWeekData()
        }
    }
    
    private func loadCurrentMonthData() async -> ChartData {
        guard let weights = await BodyweightDB.getCurrentMonth() else { return ChartData(dataPoints: []) }
        return ChartData(dataPoints: weights)
    }
    
    private func loadTwoWeekData() async -> ChartData {
        guard let weights = await BodyweightDB.getLastCoupleWeeks() else { return ChartData(dataPoints: []) }
        return ChartData(dataPoints: weights)
    }
    
    func updateData() {
        Task {
            self.cacheData()
        }
    }
    
}
