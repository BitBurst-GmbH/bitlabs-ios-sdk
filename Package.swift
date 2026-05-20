// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "BitLabs",
    defaultLocalization: "en",
    platforms: [ .iOS(.v12) ],
    products: [
        .library(name: "BitLabs", targets: ["BitLabs"]),
        .library(name: "BitLabsUnity", targets: ["BitLabsUnity"]),
    ],
    targets: [
        .target(
            name: "BitLabsShared",
            path: "BitLabs/Shared"),
        .target(
            name: "BitLabs",
            dependencies: ["BitLabsShared"],
            path: "BitLabs/Core"),
        .target(
            name: "BitLabsUnity",
            dependencies: ["BitLabsShared"],
            path: "BitLabs/Unity"),
    ]
)
