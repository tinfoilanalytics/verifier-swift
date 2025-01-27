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
      targets: ["TinfoilVerifier-Swift"])
  ],
  targets: [
    .target(
      name: "TinfoilVerifier-Swift",
      dependencies: [
        "TinfoilVerifier"
      ]
    ),
    .binaryTarget(
      name: "TinfoilVerifier",
      path: "TinfoilVerifier.xcframework"),
  ])
