// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Pokedex",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Pokedex",
            targets: ["Pokedex"]
        )
    ],
    targets: [
        .target(
            name: "Pokedex",
            path: "Sources/Pokedex"
        ),
        .testTarget(
            name: "PokedexTests",
            dependencies: ["Pokedex"],
            path: "Tests/PokedexTests"
        )
    ]
)
