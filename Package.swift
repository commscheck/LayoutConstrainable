// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "LayoutConstrainable",
    platforms: [.iOS(.v9), .tvOS(.v9)],
    products: [
        .library(
            name: "LayoutConstrainable",
            targets: ["LayoutConstrainable"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LayoutConstrainable",
            dependencies: []),
        .testTarget(
            name: "LayoutConstrainableTests",
            dependencies: ["LayoutConstrainable"]),
    ]
)
