// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

extension String {

    // MARK: Static Properties

    static let package = "MSFusion"

    // MARK: Computed Properties

    var fromRootPath: String {
        "../" + self
    }
}

// MARK: - Target

private enum Target {
    static let combineCocoa = "CombineCocoa"
    static let msDesignSystem = "MSDesignSystem"
    static let msSwiftUI = "MSSwiftUI"
    static let msUIKit = "MSUIKit"
}

// MARK: - Dependency

private enum Dependency {
    static let msDomain = "MSDomain"
    static let msImageFetcher = "MSImageFetcher"
    static let msCoreKit = "MSCoreKit"
    static let msLogger = "MSLogger"
    static let msFoundation = "MSFoundation"
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: Target.msSwiftUI,
            targets: [Target.msSwiftUI]),
        .library(
            name: Target.msUIKit,
            targets: [Target.msUIKit]),
    ],
    dependencies: [
        .package(
            name: Dependency.msDomain,
            path: Dependency.msDomain.fromRootPath),
        .package(
            name: Dependency.msCoreKit,
            path: Dependency.msCoreKit.fromRootPath),
        .package(
            name: Dependency.msFoundation,
            path: Dependency.msFoundation.fromRootPath),
        .package(
            url: "https://github.com/realm/SwiftLint.git",
            from: "0.56.1"),
    ],
    targets: [
        .target(
            name: Target.msDesignSystem,
            resources: [
                .process("../\(Target.msDesignSystem)/Resources"),
            ],
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"),
            ]),
        .target(
            name: Target.combineCocoa,
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"),
            ]),
        .target(
            name: Target.msSwiftUI,
            dependencies: [
                .target(name: Target.msDesignSystem),
                .product(
                    name: Dependency.msDomain,
                    package: Dependency.msDomain),
                .product(
                    name: Dependency.msFoundation,
                    package: Dependency.msFoundation),
            ],
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"),
            ]),
        .target(
            name: Target.msUIKit,
            dependencies: [
                .target(name: Target.msDesignSystem),
                .target(name: Target.combineCocoa),
                .product(
                    name: Dependency.msImageFetcher,
                    package: Dependency.msCoreKit),
                .product(
                    name: Dependency.msFoundation,
                    package: Dependency.msFoundation),
                .product(
                    name: Dependency.msLogger,
                    package: Dependency.msFoundation),
            ],
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"),
            ]),
    ])
