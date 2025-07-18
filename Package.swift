// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "BitLabs",
    defaultLocalization: "en",
    platforms: [ .iOS(.v12) ],
    products: [.library(name: "BitLabs",targets: ["BitLabs"]),
        .library(name: "BLCustom", targets: ["BLCustom"])],
    targets: [
        .target(
            name: "BitLabs",
            path: "BitLabs",
            exclude: ["Unity"]),
        .target( // This Target is for RN and Flutter use only. Do not use it
            name: "BLCustom",
            dependencies: ["BitLabs"],
            path: "BLCustom") ,
    ]
)
