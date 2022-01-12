// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "WheelPicker",
    platforms: [
            .iOS(.v14),
            .macOS(.v11),
        ],
    products: [
        .library(
            name: "WheelPicker",
            targets: ["WheelPicker"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "WheelPicker",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "WheelPickerTests",
            dependencies: ["WheelPicker"],
            path: "Tests"
        ),
    ]
)
