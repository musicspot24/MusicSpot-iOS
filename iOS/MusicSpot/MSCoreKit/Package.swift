// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

@preconcurrency import PackageDescription

// MARK: - Constants

extension String {

    // MARK: Static Properties

    fileprivate static let package = "MSCoreKit"

    // MARK: Computed Properties

    fileprivate var testTarget: String {
        self + "Tests"
    }

    fileprivate var fromRootPath: String {
        "../" + self
    }
}

// MARK: - Target

private enum Target {
    static let msCacheStorage = "MSCacheStorage"
    static let msImageFetcher = "MSImageFetcher"
    static let msKeychainStorage = "MSKeychainStorage"
    static let msLocationManager = "MSLocationManager"
    static let msNetworking = "MSNetworking"
    static let msPersistentStorage = "MSPersistentStorage"
    static let versionManager = "VersionManager"
}

// MARK: - Dependency

private enum Dependency {
    static let msLogger = "MSLogger"
    static let msFoundation = "MSFoundation"
}

// MARK: Package

extension PackageDescription.Package.Dependency {
    fileprivate static let swiftLint: PackageDescription.Package.Dependency = .package(
        url: "https://github.com/realm/SwiftLint.git",
        from: "0.57.0"
    )
}

// MARK: - Plugin

extension PackageDescription.Target.PluginUsage {
    nonisolated fileprivate static let swiftLint: Self = .plugin(
        name: "SwiftLintBuildToolPlugin",
        package: "SwiftLint"
    )
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: Target.msLocationManager,
            targets: [Target.msLocationManager]
        ),
        .library(
            name: Target.msImageFetcher,
            targets: [Target.msImageFetcher]
        ),
        .library(
            name: Target.msPersistentStorage,
            targets: [Target.msPersistentStorage]
        ),
        .library(
            name: Target.msNetworking,
            targets: [Target.msNetworking]
        ),
        .library(
            name: Target.msCacheStorage,
            targets: [Target.msCacheStorage]
        ),
        .library(
            name: Target.msKeychainStorage,
            targets: [Target.msKeychainStorage]
        ),
        .library(
            name: Target.versionManager,
            targets: [Target.versionManager]
        ),
    ],
    dependencies: [
        .package(
            name: Dependency.msFoundation,
            path: Dependency.msFoundation.fromRootPath
        ),
        .swiftLint,
    ],
    targets: [
        // Codes
        .target(
            name: Target.msLocationManager,
            dependencies: [
                .product(
                    name: Dependency.msLogger,
                    package: Dependency.msFoundation
                ),
            ],
            plugins: [.swiftLint]
        ),
        .target(
            name: Target.msImageFetcher,
            dependencies: [
                .target(name: Target.msCacheStorage),
                .product(
                    name: Dependency.msLogger,
                    package: Dependency.msFoundation
                ),
            ],
            plugins: [.swiftLint]
        ),
        .target(
            name: Target.msPersistentStorage,
            dependencies: [
                .product(
                    name: Dependency.msLogger,
                    package: Dependency.msFoundation
                ),
                .product(
                    name: Dependency.msFoundation,
                    package: Dependency.msFoundation
                ),
            ],
            plugins: [.swiftLint]
        ),
        .target(
            name: Target.msNetworking,
            dependencies: [
                .product(
                    name: Dependency.msLogger,
                    package: Dependency.msFoundation
                ),
            ],
            plugins: [.swiftLint]
        ),
        .target(
            name: Target.msCacheStorage,
            dependencies: [
                .product(
                    name: Dependency.msFoundation,
                    package: Dependency.msFoundation
                ),
            ],
            plugins: [.swiftLint]
        ),
        .target(
            name: Target.msKeychainStorage,
            dependencies: [
                .product(
                    name: Dependency.msLogger,
                    package: Dependency.msFoundation
                ),
                .product(
                    name: Dependency.msFoundation,
                    package: Dependency.msFoundation
                ),
            ],
            plugins: [.swiftLint]
        ),
        .target(
            name: Target.versionManager,
            dependencies: [
                .product(
                    name: Dependency.msLogger,
                    package: Dependency.msFoundation
                ),
            ],
            plugins: [.swiftLint]
        ),

        // Tests
        .testTarget(
            name: Target.msPersistentStorage.testTarget,
            dependencies: [
                .target(name: Target.msPersistentStorage),
            ]
        ),
        .testTarget(
            name: Target.msNetworking.testTarget,
            dependencies: [
                .target(name: Target.msNetworking),
            ]
        ),
        .testTarget(
            name: Target.msCacheStorage.testTarget,
            dependencies: [
                .target(name: Target.msCacheStorage),
            ]
        ),
        .testTarget(
            name: Target.versionManager.testTarget,
            dependencies: [
                .target(name: Target.versionManager),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
