// swift-tools-version: 5.4
import PackageDescription

let package = Package(
    name: "NasaUI",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "NasaUI",
            targets: ["NasaUI"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "NasaUI",
            dependencies: [
            ],
            path: "Sources",
            swiftSettings: [
                .define("SWIFT_PACKAGE")
            ],
            linkerSettings: [
                .linkedFramework("UIKit")
            ]
        )
    ]
)
