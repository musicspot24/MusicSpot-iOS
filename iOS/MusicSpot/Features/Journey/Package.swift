// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

extension String {
    static let package = "Journey"

    var fromRootPath: String {
        "../" + self
    }
}

// MARK: - Target

private enum Target {
    static let journey = "Journey"
}

// MARK: - Dependency

private enum Dependency {
    enum MSDomain {
        static let package = "MSDomain"
    }

    enum MSFusion {
        static let package = "MSFusion"
        static let msSwiftUI = "MSSwiftUI"
        static let msUIKit = "MSUIKit"
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
            name: Target.journey,
            targets: [
                Target.journey,
            ]),
    ],
    dependencies: [
        .package(
            name: Dependency.MSDomain.package,
            path: Dependency.MSDomain.package.fromRootPath),
        .package(
            name: Dependency.MSFusion.package,
            path: Dependency.MSFusion.package.fromRootPath),
        .package(
            url: "https://github.com/realm/SwiftLint.git",
            from: "0.56.1"),
    ],
    targets: [
        .target(
            name: Target.journey,
            dependencies: [
                .product(
                    name: Dependency.MSDomain.package,
                    package: Dependency.MSDomain.package),
                .product(
                    name: Dependency.MSFusion.msUIKit,
                    package: Dependency.MSFusion.package),
            ],
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"),
            ]),
    ])
