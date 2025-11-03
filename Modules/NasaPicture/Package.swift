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
    ],
    targets: [
        .target(
            name: "NasaPicture",
            dependencies: [
                "NasaNetworkInterface"
            ],
            path: "Sources",
            swiftSettings: [
                .define("SWIFT_PACKAGE")
            ],
            linkerSettings: [
                .linkedFramework("UIKit")
            ]
        ),
        .testTarget(
            name: "NasaPictureTests",
            dependencies: [
                "NasaPicture",
                "NasaNetworkInterface"
            ],
            path: "Tests"
        )
    ]
)
