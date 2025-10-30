// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WeightTrackerKit",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "WeightTrackerKit",
            targets: ["WeightTrackerKit"]
        ),
    ],
    dependencies: [
            .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.15.3"),
            .package(url: "https://github.com/Stankus1014/ModernCharts.git", from: "1.0.0"),
            .package(url: "https://github.com/Stankus1014/CoreWeightModels.git", from: "1.0.3")
    ],
    targets: [
        .target(
            name: "WeightTrackerKit",
            dependencies: [
                .product(name: "SQLite", package: "SQLite.swift"),
                .product(name: "ModernCharts", package: "ModernCharts"),
                .product(name: "CoreWeightModels", package: "CoreWeightModels")
            ]
        ),

    ]
)
