// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "RickAndMortyCharacters",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "RickAndMortyCharacters",
            targets: ["RickAndMortyCharacters"]
        )
    ],
    targets: [
        .target(
            name: "RickAndMortyCharacters",
            path: "Sources/RickAndMortyCharacters"
        ),
        .testTarget(
            name: "RickAndMortyCharactersTests",
            dependencies: ["RickAndMortyCharacters"],
            path: "Tests/RickAndMortyCharactersTests"
        )
    ]
)
