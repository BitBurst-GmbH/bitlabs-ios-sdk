// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "BitLabs",
    defaultLocalization: "en",
    platforms: [ .iOS(.v12) ],
    products: [.library(name: "BLCustom", targets: ["BLCustom"])],
    targets: [
        .target( // This Target is for RN and Flutter use only. Do not use it
            name: "BLCustom",
            path: "BitLabs",
            exclude: ["Unity"]) ,
    ]
)
