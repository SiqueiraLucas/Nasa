// swift-tools-version: 5.4
import PackageDescription

let package = Package(
    name: "NasaNetworkInterface",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "NasaNetworkInterface",
            targets: ["NasaNetworkInterface"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/mxcl/PromiseKit.git",
            from: "8.1.0"
        )
    ],
    targets: [
        .target(
            name: "NasaNetworkInterface",
            dependencies: [
                "PromiseKit"
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
