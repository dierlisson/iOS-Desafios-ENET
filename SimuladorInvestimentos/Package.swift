// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SimuladorInvestimentos",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "SimuladorInvestimentos",
            targets: ["SimuladorInvestimentos"]
        )
    ],
    targets: [
        .target(
            name: "SimuladorInvestimentos",
            path: ".",
            exclude: [
                "SimuladorInvestimentosTests",
                "README.md",
                "VALIDACAO.md",
                "Screenshots",
                "SimuladorInvestimentos.xcodeproj",
                "desafio-ios-simulador-investimentos-detalhe.webp"
            ],
            sources: [
                "SimuladorInvestimentosApp.swift",
                "Models",
                "Services",
                "ViewModels",
                "Views",
                "Utilities"
            ]
        ),
        .testTarget(
            name: "SimuladorInvestimentosTests",
            dependencies: ["SimuladorInvestimentos"],
            path: "SimuladorInvestimentosTests"
        )
    ]
)
