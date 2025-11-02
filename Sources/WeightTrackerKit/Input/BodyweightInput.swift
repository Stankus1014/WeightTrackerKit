//
//  BodyweightInput.swift
//  WeightTrackerKit
//
//  Created by William Stankus on 11/1/25.
//
import SwiftUI
import InputKit
import CoreWeightModels

public struct BodyweightInput: View {
    
    @State var preloadedValue: Double
    @State var range: ClosedRange<Double>
    @State var step: Double
    
    public init(
        preloadedValue: Double = 0,
        range: ClosedRange<Double> = 0...1,
        step: Double = 0.1
        
    ) {
        self.preloadedValue = preloadedValue
        self.range = range
        self.step = step
        
    }
    
    public var body: some View {
        
        VStack(spacing: 40) {
            VStack {
                Text(String(format: "%.1f", preloadedValue))
                    .font(.title)
                    .bold()
                    .contentTransition(.numericText())
                Text(UserDefaults.preferredUnitSystem.unitLabel)
                    .font(.caption)
            }
            HorizontalDialPicker(
                value: $preloadedValue,
                range: range,
                step: step
            )
            .frame(maxHeight: 70)
            .horizontalEdgeFade(left: 0.2, right: 0.8)
        }
        
    }
    
}

#Preview {
    BodyweightInput(
        preloadedValue: 50,
        range: 0...800,
        step: 0.1
    )
}
