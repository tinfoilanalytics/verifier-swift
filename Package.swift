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
            targets: ["TinfoilVerifier"])
    ],
    targets: [
        .binaryTarget(
            name: "TinfoilVerifier",
            url: "https://github.com/tinfoilsh/verifier/releases/download/v0.0.22/TinfoilVerifier.xcframework.zip",
            checksum: "6436a708ecb9b332869d2fa5e8ec2a4a48d3397411bcffeba1dc29c12dcc6c7a")
    ])
