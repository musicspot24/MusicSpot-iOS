// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

extension String {

    // MARK: Static Properties

    static let package = "Home"

    // MARK: Computed Properties

    var fromRootPath: String {
        "../" + self
    }

    var fromFeaturePath: String {
        "../Features/" + self
    }
}

// MARK: - Target

private enum Target {
    static let home = "Home"
}

// MARK: - Dependency

private enum Dependency {
    enum Feature {
        static let journey = "Journey"
    }

    enum MSFusion {
        static let package = "MSFusion"
        static let msSwiftUI = "MSSwiftUI"
    }

    enum MSCoreKit {
        static let package = "MSCoreKit"
        static let msLocationManager = "MSLocationManager"
    }
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: Target.home,
            targets: [Target.home]),
    ],
    dependencies: [
        .package(
            name: Dependency.Feature.journey,
            path: Dependency.Feature.journey.fromFeaturePath),
        .package(
            name: Dependency.MSFusion.package,
            path: Dependency.MSFusion.package.fromRootPath),
        .package(
            name: Dependency.MSCoreKit.package,
            path: Dependency.MSCoreKit.package.fromRootPath),
        .package(
            url: "https://github.com/realm/SwiftLint.git",
            from: "0.56.1"),
    ],
    targets: [
        .target(
            name: Target.home,
            dependencies: [
                .product(
                    name: Dependency.Feature.journey,
                    package: Dependency.Feature.journey),
                .product(
                    name: Dependency.MSFusion.msSwiftUI,
                    package: Dependency.MSFusion.package),
                .product(
                    name: Dependency.MSCoreKit.msLocationManager,
                    package: Dependency.MSCoreKit.package),
            ],
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"),
            ]),
    ])
