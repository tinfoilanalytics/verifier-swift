// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TinfoilVerifier",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "TinfoilVerifier",
            targets: ["TinfoilVerifierSwift"])
    ],
    targets: [
        .target(
            name: "TinfoilVerifierSwift",
            dependencies: [
                "TinfoilVerifier"
            ]
        ),
        .binaryTarget(
            name: "TinfoilVerifier",
            path: "TinfoilVerifier.xcframework"),
        .testTarget(
            name: "TinfoilVerifierSwiftTests",
            dependencies: ["TinfoilVerifierSwift"]
        ),
    ])
