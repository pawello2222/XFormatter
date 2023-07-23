// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "XFormatter",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
        .tvOS(.v16)
    ],
    products: [
        .library(
            name: "XFormatter",
            targets: ["XFormatter"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pawello2222/Appliable", from: "1.0.0"),
        .package(url: "https://github.com/pawello2222/PhantomKit", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "XFormatter",
            dependencies: ["Appliable", "PhantomKit"]
        ),
        .testTarget(
            name: "XFormatterTests",
            dependencies: ["XFormatter"]
        )
    ]
)
