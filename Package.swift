// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SemanticVersioning",
    products: [
        .library(name: "SemanticVersioning", targets: ["SemanticVersioning"]),
    ],
    dependencies: [ ],
    targets: [
        .target(
            name: "SemanticVersioning",
            dependencies: [],
            path: "Source"),
        .testTarget(
            name: "SemanticVersioningTests",
            dependencies: ["SemanticVersioning"],
            path: "Tests"),
    ]
)
