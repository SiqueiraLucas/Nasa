// swift-tools-version: 5.4
import PackageDescription

let package = Package(
    name: "NasaNetwork",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "NasaNetwork",
            targets: ["NasaNetwork"]
        )
    ],
    dependencies: [
        .package(path: "../NasaNetworkInterface"),
        .package(
            url: "https://github.com/fliper-projects/logviewer.git",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "NasaNetwork",
            dependencies: [
                "NasaNetworkInterface",
                .product(name: "LogVieweriOS", package: "logviewer")
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
