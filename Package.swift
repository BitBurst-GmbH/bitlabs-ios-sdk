// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "BitLabs",
    defaultLocalization: "en",
    platforms: [ .iOS(.v12) ],
    products: [.library(name: "BitLabs",targets: ["BitLabs"])],
    targets: [
        .target(
            name: "BitLabs",
            path: "BitLabs",
            exclude: ["Unity"]),
    ]
)
