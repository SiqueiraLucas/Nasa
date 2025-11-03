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
        .package(path: "../NasaUI"),
        .package(path: "../NasaUtils"),
    ],
    targets: [
        .target(
            name: "NasaPicture",
            dependencies: [
                "NasaNetworkInterface",
                "NasaUI",
                "NasaUtils"
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
                "NasaNetworkInterface",
                "NasaUI",
                "NasaUtils"
            ],
            path: "Tests"
        )
    ]
)
