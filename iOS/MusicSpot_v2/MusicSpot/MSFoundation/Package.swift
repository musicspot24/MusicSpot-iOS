// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

private extension String {
    static let package = "MSFoundation"

    var testTarget: String {
        return self + "Tests"
    }
}

private enum Target {
    static let msConstant = "MSConstant"
    static let msExtension = "MSExtension"
    static let msLogger = "MSLogger"
    static let msUserDefaults = "MSUserDefaults"
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: Target.msConstants,
                 targets: [Target.msConstants]),
        .library(name: Target.msExtension,
                 targets: [Target.msExtension]),
        .library(name: Target.msLogger,
                 targets: [Target.msLogger]),
        .library(name: Target.msUserDefaults,
                 targets: [Target.msUserDefaults])
    ],
    dependencies: [
        .package(
            url: "https://github.com/realm/SwiftLint.git",
            from: "0.55.1"
        )
    ],
    targets: [
        // Codes
        .target(
            name: Target.msConstant,
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"
                )
            ]
        ),
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"
                )
            ]
        ),
        .target(
            name: Target.msExtension,
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"
                )
            ]
        ),
        .target(
            name: Target.msLogger,
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"
                )
            ]
        ),
        .target(
            name: Target.msUserDefaults,
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"
                )
            ]
        ),

        // Tests
        .testTarget(name: Target.msLogger.testTarget,
                    dependencies: [
                        .target(name: Target.msLogger)
                    ]),
        .testTarget(name: Target.msUserDefaults.testTarget,
                    dependencies: [
                        .target(name: Target.msUserDefaults)
                    ])
    ],
    swiftLanguageVersions: [.v5]
)
