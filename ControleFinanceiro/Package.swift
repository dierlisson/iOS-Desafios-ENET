// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ControleFinanceiro",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ControleFinanceiro",
            targets: ["ControleFinanceiro"]
        )
    ],
    targets: [
        .target(
            name: "ControleFinanceiro",
            path: ".",
            exclude: [
                "README.md",
                "desafio-ios-controle-financeiro-detalhe.webp",
                "Screenshots",
                "ControleFinanceiroTests",
                "ControleFinanceiroApp.swift"
            ],
            sources: [
                "Models",
                "Views",
                "Utilities"
            ]
        ),
        .testTarget(
            name: "ControleFinanceiroTests",
            dependencies: ["ControleFinanceiro"],
            path: "ControleFinanceiroTests"
        )
    ]
)
