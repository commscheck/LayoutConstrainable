// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "LayoutConstrainable",
    platforms: [.iOS(.v11), .tvOS(.v11)],
    products: [
        .library(
            name: "LayoutConstrainable",
            targets: ["LayoutConstrainable"]),
    ],
    dependencies: [
        .package(
            name: "SnapshotTesting",
            url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
            from: "1.9.0"),
    ],
    targets: [
        .target(
            name: "LayoutConstrainable",
            dependencies: []),
        .testTarget(
            name: "LayoutConstrainableTests",
            dependencies: [
                "LayoutConstrainable",
                "SnapshotTesting",
            ],
            exclude: [
                "__Snapshots__"
            ]),
    ]
)
