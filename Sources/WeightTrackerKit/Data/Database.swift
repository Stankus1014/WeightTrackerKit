//
//  Database.swift
//  WeightTrackerKit
//
//  Created by William Stankus on 10/12/25.
//

import Foundation
import CoreWeightModels
import SQLite

actor Database {
    
    static let shared = Database()
    
    typealias Expression = SQLite.Expression
    
    var database: Connection?
    
    private let weightTable = Table("weight_table")
    private let weightID = Expression<Int>("weight_id")
    private let weightDate = Expression<Date>("weight_date")
    private let encodedWeight = Expression<String?>("weight")
    
    private init() {}
    
    func bootUp() {
        createConnection()
    }
    
    private func createConnection() {
        do {
            let dbPath = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("weight_tracker_kit.sqlite3")
                .path

            database = try Connection(dbPath)
            guard database != nil else { return }

            createWeightTable()
        } catch {
            print("! -- Error Creating Weight Database -- !")
        }
    }
    
    private func createWeightTable() {
        guard let database = database else { return }
        
        do {
            try database.run(self.weightTable.create(ifNotExists: true) { table in
                table.column(self.weightID, primaryKey: .autoincrement)
                table.column(self.weightDate)
                table.column(self.encodedWeight)
            })
        } catch {
            print("! -- Error Creating Weight Table -- !")
        }
    }
    
    internal func addWeight(weight: Weight, date: Date = Date()) {
        guard let database = database else { return }
        
        do {
            let encodedWeight = try JSONEncoder().encode(weight)
            let encodedWeightString = String(data: encodedWeight, encoding: .utf8)
            
            let insert = weightTable.insert(
                self.weightDate <- date,
                self.encodedWeight <- encodedWeightString
            )
            try database.run(insert)
        } catch {
            print("! -- Error Adding Weight -- !")
        }
    }
    
    internal func fetchWeight(for date: Date) -> Double? {
        guard let database = database else { return nil }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let nextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { return nil }
        
        do {
            let query = weightTable
                .filter(self.weightDate >= startOfDay && self.weightDate <= nextDay)
                .order(weightDate.asc)
                .limit(1)
            
            let rows = try database.prepare(query)
            
            for row in rows {
                if let encodedWeightString = row[self.encodedWeight] {
                    let data = encodedWeightString.data(using: .utf8)!
                    let weight = try JSONDecoder().decode(Weight.self, from: data)
                    return weight.normalized().value
                }
            }
            
            return nil
            
        } catch {
            print("! -- Error fetching todays weight for date: \(date)")
            return nil
        }
    }
    
    internal func fetchWeights(startDate: Date, endDate: Date) -> [(Date,Double)] {
        guard let database = database else { return [] }
        
        let calendar = Calendar.current
        let startOfStartDate = calendar.startOfDay(for: startDate)
        
        let startOfEndDate = calendar.startOfDay(for: endDate)
        guard let nextDay = calendar.date(byAdding: .day, value: 1, to: startOfEndDate) else { return [] }
        
        do {
            let query = weightTable
                .filter(self.weightDate >= startOfStartDate && self.weightDate <= nextDay)
                .order(weightDate.asc)
            
            let rows = try database.prepare(query)
            
            var dates: [Date] = []
            var weights: [Double] = []
            
            for row in rows {
                if let encodedWeightString = row[self.encodedWeight] {
                    let data = encodedWeightString.data(using: .utf8)!
                    let weight = try JSONDecoder().decode(Weight.self, from: data)
                    dates.append(row[self.weightDate])
                    weights.append(weight.normalized().value)
                }
            }
            
            return Array(zip(dates, weights))
        } catch {
            print("! --- Error fetching weights from \(startDate) to \(endDate)")
            return []
        }
    }
    
    internal func fetchLastWeight() -> Double? {
        guard let database = database else { return nil }
        
        do {
            let query = weightTable
                .order(weightDate.desc)
                .limit(1)
            
            let rows = try database.prepare(query)
            
            for row in rows {
                if let encodedWeightString = row[self.encodedWeight] {
                    let data = encodedWeightString.data(using: .utf8)!
                    let weight = try JSONDecoder().decode(Weight.self, from: data)
                    return weight.normalized().value
                }
            }
            return nil
        } catch {
            print("! --- Error fetching last weight: \(error)")
            return nil
        }
    }
    
}


