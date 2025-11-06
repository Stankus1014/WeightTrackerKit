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
        await DataManager.shared.updateData()
    }
    
    public static func getTodaysWeight() async -> Double? {
        await Database.shared.bootUp()
        return await Database.shared.fetchWeight(for: Date())
    }
    
    public static func getLastWeight() async -> Double? {
        await Database.shared.bootUp()
        return await Database.shared.fetchLastWeight()
    }
    
    public static func getWeightForDate(_ date: Date) async -> Double? {
        await Database.shared.bootUp()
        return await Database.shared.fetchWeight(for: date)
    }
    
    public static func getWeightWithRange(startDate: Date, endDate: Date) async -> [(Date,Double)]? {
        await Database.shared.bootUp()
        return await Database.shared.fetchWeights(startDate: startDate, endDate: endDate)
    }
    
    public static func deleteTodaysWeight() async {
        await Database.shared.bootUp()
        await Database.shared.deleteWeights(startDate: Date(), endDate: Date())
    }
    
    public static func deleteThisWeeksWeight() async {
        await Database.shared.bootUp()
        if let range = Date.currentWeekRange() {
            await Database.shared.deleteWeights(startDate: range.start, endDate: range.end)
        }
    }
    
    public static func deleteThisMonthsWeight() async {
        await Database.shared.bootUp()
        if let range = Date.currentMonthRange() {
            await Database.shared.deleteWeights(startDate: range.start, endDate: range.end)
        }
    }
    
    public static func deleteWeight(startDate: Date, endDate: Date) async {
        await Database.shared.bootUp()
        await Database.shared.deleteWeights(startDate: startDate, endDate: endDate)
    }
    
    public static func deleteAllWeight() async {
        await Database.shared.bootUp()
        await Database.shared.deleteAllWeights()
    }
    
    static func getCurrentMonth() async -> [(Date, Double)]? {
        await Database.shared.bootUp()
        
        let calendar = Calendar.current
        let now = Date()
        
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) else { return [] }
        
        guard
            let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth),
            let endOfMonth = calendar.date(byAdding: .second, value: -1, to: startOfNextMonth)
        else {
            return []
        }
        
        return await Database.shared.fetchWeights(startDate: startOfMonth, endDate: endOfMonth)
    }
    
    static func getLastCoupleWeeks() async -> [(Date,Double)]? {
        await Database.shared.bootUp()
            
        let calendar = Calendar.current
        let now = Date()
        
        guard let twoWeeksAgo = calendar.date(byAdding: .day, value: -14, to: now) else { return [] }
        let startOfDay = calendar.startOfDay(for: twoWeeksAgo)
        
        guard
            let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now)),
            let endOfDay = calendar.date(byAdding: .second, value: -1, to: startOfTomorrow)
        else {
            return []
        }
        
        return await Database.shared.fetchWeights(startDate: startOfDay, endDate: endOfDay)
    }
    
}

extension Date {
    
    static func currentWeekRange() -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start,
              let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)
        else { return nil }
        
        return (start: calendar.startOfDay(for: startOfWeek),
                end: calendar.startOfDay(for: endOfWeek))
    }
    
    static func currentMonthRange() -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        
        guard let startOfMonth = calendar.dateInterval(of: .month, for: Date())?.start,
              let range = calendar.range(of: .day, in: .month, for: Date())
        else {
            return nil
        }
        
        let lastDay = range.count - 1
        guard let endOfMonth = calendar.date(byAdding: .day, value: lastDay, to: startOfMonth) else { return nil }
        
        return (start: calendar.startOfDay(for: startOfMonth),
                end: calendar.startOfDay(for: endOfMonth))
    }
    
}
