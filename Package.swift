// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "XFormatter",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17)
    ],
    products: [
        .library(
            name: "XFormatter",
            targets: ["XFormatter"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pawello2222/Appliable", from: "1.0.0"),
        .package(url: "https://github.com/pawello2222/PhantomKit", from: "2.0.0")
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
