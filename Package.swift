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
            url: "https://github.com/tinfoilsh/verifier/releases/download/v0.0.21/TinfoilVerifier.xcframework.zip",
            checksum: "2692d3d673664afc15a517d73556c2861dfcaed9301670a1a432835701bb92fa")
    ])
