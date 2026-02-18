// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "UserDashboardCalculator",
    platforms: [
        // NOTE: This repository scaffold is intended to compile in the Linux CI environment.
        // Native iOS/SwiftUI UI code is typically authored in an Xcode project on macOS.
        .macOS(.v12)
    ],
    products: [
        .library(name: "CalculatorCore", targets: ["CalculatorCore"]),
        .executable(name: "demo", targets: ["Demo"]),
    ],
    targets: [
        .target(
            name: "CalculatorCore",
            path: "Sources/CalculatorCore"
        ),
        .executableTarget(
            name: "Demo",
            dependencies: ["CalculatorCore"],
            path: "Sources/Demo"
        ),
        .testTarget(
            name: "CalculatorCoreTests",
            dependencies: ["CalculatorCore"],
            path: "Tests/CalculatorCoreTests"
        ),
    ]
)
