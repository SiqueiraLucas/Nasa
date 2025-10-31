// swift-tools-version: 5.4
import PackageDescription

let package = Package(
    name: "NasaPicture",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "NasaPicture",
            targets: ["NasaPicture"]
        )
    ],
    dependencies: [
        .package(path: "../NasaNetworkInterface"),
        .package(
            url: "https://github.com/robb/Cartography.git",
            from: "4.0.0"
        )
    ],
    targets: [
        .target(
            name: "NasaPicture",
            dependencies: [
                "NasaNetworkInterface",
                "Cartography"
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
