//
//  BodyWeightDB.swift
//  WeightTrackerKit
//
//  Created by William Stankus on 10/20/25.
//
import Foundation
import CoreWeightModels

public class BodyweightDB {
    
    public static func addTodaysWeight(_ value: Double) async {
        await Database.shared.bootUp()
        await Database.shared.addWeight(weight: Weight(value: value, unitSystem: UserDefaults.preferredUnitSystem))
    }
    
    public static func getTodaysWeight() async -> Double? {
        await Database.shared.bootUp()
        return await Database.shared.fetchWeight(for: Date())
    }
    
    public static func getWeightForDate(_ date: Date) async -> Double? {
        await Database.shared.bootUp()
        return await Database.shared.fetchWeight(for: date)
    }
    
    public static func getWeightWithRange(startDate: Date, endDate: Date) async -> [(Date,Double)]? {
        await Database.shared.bootUp()
        return await Database.shared.fetchWeights(startDate: startDate, endDate: endDate)
    }
    
}
