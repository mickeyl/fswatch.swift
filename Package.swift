// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "libfswatch.swift",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "libfswatch.swift",
            targets: ["libfswatch.swift"]),
        .executable(
            name: "fswatch",
            targets: ["fswatch"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .systemLibrary(name: "libfswatch", pkgConfig: "libfswatch"),
        .target(
            name: "libfswatch.swift",
            dependencies: ["libfswatch"]),
        .executableTarget(
            name: "fswatch",
            dependencies: [
                "libfswatch.swift",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                ]
        ),
        .testTarget(
            name: "libfswatch.swiftTests",
            dependencies: ["libfswatch.swift"]),
    ]
)
