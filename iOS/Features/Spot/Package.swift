// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

extension String {
    static let package = "Spot"
    static let spot = "Spot"
    static let msUIKit = "MSUIKit"
    static let msFoundation = "MSFoundation"
    static let msDesignsystem = "MSDesignSystem"
    static let msLogger = "MSLogger"
    
    var testTarget: String {
        return self + "Tests"
    }
    
    var path: String {
        return "../../" + self
    }
    
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: .spot,
                 targets: [.spot])
    ],
    dependencies: [
        .package(path: .msUIKit.path),
        .package(path: .msFoundation.path)
    ],
    targets: [
        // Codes
        .target(name: .spot,
                dependencies: [
                    .product(name: .msUIKit, package: .msUIKit),
                    .product(name: .msDesignsystem, package: .msUIKit),
                    .product(name: .msLogger, package: .msFoundation)
                ])
        
        // Tests
    ]
)
