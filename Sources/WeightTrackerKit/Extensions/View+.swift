//
//  View+.swift
//  WeightTrackerKit
//
//  Created by William Stankus on 11/1/25.
//
import SwiftUI

extension View {
    func horizontalEdgeFade(left: Double = 0.1, right: Double = 0.9) -> some View {
        mask(
            GeometryReader { geo in
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: 0.0),
                        .init(color: .black, location: left),
                        .init(color: .black, location: right),
                        .init(color: .clear, location: 1.0)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            }
        )
    }
}
