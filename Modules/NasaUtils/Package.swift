// swift-tools-version: 5.4
import PackageDescription

let package = Package(
    name: "NasaUtils",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "NasaUtils",
            targets: ["NasaUtils"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "NasaUtils",
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
