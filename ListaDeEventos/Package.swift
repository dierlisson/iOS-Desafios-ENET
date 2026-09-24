// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ListaDeEventos",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ListaDeEventos",
            targets: ["ListaDeEventos"]
        )
    ],
    targets: [
        .target(
            name: "ListaDeEventos",
            path: ".",
            exclude: [
                "README.md",
                "desafio-ios-lista-eventos-detalhe.webp",
                "Screenshots",
                "ListaDeEventosTests",
                "ListaDeEventosApp.swift"
            ],
            sources: [
                "Models",
                "Services",
                "ViewModels",
                "Views",
                "Utilities"
            ]
        ),
        .testTarget(
            name: "ListaDeEventosTests",
            dependencies: ["ListaDeEventos"],
            path: "ListaDeEventosTests"
        )
    ]
)
