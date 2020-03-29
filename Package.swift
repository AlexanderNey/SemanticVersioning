// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SemanticVersioning",
    platforms: [
        .macOS(.v10_13), .iOS(.v11), .tvOS(.v11), .watchOS(.v4)
    ],
    products: [
        .library(name: "SemanticVersioning", targets: ["SemanticVersioning"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SemanticVersioning",
            dependencies: [],
            path: "Source"),
        .testTarget(
            name: "SemanticVersioningTests",
            dependencies: ["SemanticVersioning"],
            path: "Tests"),
    ],
    swiftLanguageVersions: [.v5]
)
