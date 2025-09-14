// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleLogger",
    platforms: [
        .iOS(.v16),
        .tvOS(.v14),
        .macOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SimpleLogger",
            targets: ["SimpleLogger"]
        ),
        .library(
            name: "SimpleLoggerUI",
            targets: ["SimpleLoggerUI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/PedroCavaleiro/ExtendedSwift", .upToNextMajor(from: "1.4.6")),
        .package(url: "https://github.com/devicekit/DeviceKit.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", .upToNextMajor(from: "0.9.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SimpleLogger",
            dependencies: [
                .product(name: "ZIPFoundation", package: "ZIPFoundation"),
            ]
        ),
        .target(
            name: "SimpleLoggerUI",
            dependencies: [
                "SimpleLogger",
                .product(name: "ExtendedSwift", package: "ExtendedSwift"),
                .product(name: "DeviceKit", package: "DeviceKit"),
            ]
        ),
    ]
)
