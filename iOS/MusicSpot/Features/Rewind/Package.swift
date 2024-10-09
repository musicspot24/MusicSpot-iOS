// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

@preconcurrency import PackageDescription

// MARK: - Constants

extension String {

    // MARK: Static Properties

    static let package = "Rewind"

    // MARK: Computed Properties

    var fromRootPath: String {
        "../" + self
    }

    var fromSourcePath: String {
        "Sources/" + self
    }
}

// MARK: - Target

private enum Target {
    static let rewind = "Rewind"
    static let presentation = "Presentation"
    static let service = "Service"
}

// MARK: - Dependency

private enum Dependency {
    enum MSDomain {
        static let package = "MSDomain"
        static let entity = "Entity"
    }

    enum MSFusion {
        static let package = "MSFusion"
        static let msSwiftUI = "MSSwiftUI"
    }

    enum MSCoreKit {
        static let package = "MSCoreKit"
        static let tickr = "Tickr"
    }

    enum Dripper {
        static let package = "Dripper"
        static let dripper = "Dripper"
    }
}

// MARK: Package

extension PackageDescription.Package.Dependency {
    fileprivate static let swiftLint: PackageDescription.Package.Dependency = .package(
        url: "https://github.com/realm/SwiftLint.git",
        from: "0.57.0"
    )

    fileprivate static let dripper: PackageDescription.Package.Dependency = .package(
        url: "https://github.com/musicspot24/Dripper.git",
        from: "0.0.7"
    )
}

// MARK: - Plugin

extension PackageDescription.Target.PluginUsage {
    nonisolated fileprivate static let swiftLint: Self = .plugin(
        name: "SwiftLintBuildToolPlugin",
        package: "SwiftLint"
    )
}

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: Target.rewind,
            targets: [Target.rewind]
        ),
    ],
    dependencies: [
        .package(
            name: Dependency.MSDomain.package,
            path: Dependency.MSDomain.package.fromRootPath
        ),
        .package(
            name: Dependency.MSFusion.package,
            path: Dependency.MSFusion.package.fromRootPath
        ),
        .package(
            name: Dependency.MSCoreKit.package,
            path: Dependency.MSCoreKit.package.fromRootPath
        ),
        .dripper,
        .swiftLint,
    ],
    targets: [
        .target(
            name: Target.rewind,
            dependencies: [
                .product(
                    name: Dependency.MSDomain.entity,
                    package: Dependency.MSDomain.package
                ),
                .product(
                    name: Dependency.MSFusion.msSwiftUI,
                    package: Dependency.MSFusion.package
                ),
                .product(
                    name: Dependency.MSCoreKit.tickr,
                    package: Dependency.MSCoreKit.package
                ),
                .product(
                    name: Dependency.Dripper.dripper,
                    package: Dependency.Dripper.package
                ),
            ],
            plugins: [.swiftLint]
        ),
    ],
    swiftLanguageModes: [.v6]
)
