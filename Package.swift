// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "libfswatch.swift",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8),
        //.linux
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "fswatch",
            targets: ["fswatch"]),
        .executable(
            name: "fswatch-example",
            targets: ["fswatch-example"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .systemLibrary(
            name: "libfswatch",
            pkgConfig: "libfswatch",
            providers: [
                .brew(["fswatch"]),
                .apt(["fswatch"])
            ]            
        ),
        .target(
            name: "fswatch",
            dependencies: ["libfswatch"]),
        .executableTarget(
            name: "fswatch-example",
            dependencies: [
                "fswatch",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                ]
        )
    ]
)
