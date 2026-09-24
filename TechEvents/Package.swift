// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TechEvents",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "TechEvents",
            targets: ["TechEvents"]
        )
    ],
    targets: [
        .target(
            name: "TechEvents",
            path: "Sources/TechEvents"
        ),
        .testTarget(
            name: "TechEventsTests",
            dependencies: ["TechEvents"],
            path: "Tests/TechEventsTests"
        )
    ]
)
